# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_WITHOUT="development:test" \
  BUNDLE_DEPLOYMENT="1"

# Update gems and bundler
RUN gem update --system --no-document && \
  gem install -N bundler

# Throw-away build stages to reduce size of final image
FROM base as prebuild

# Install packages needed to build gems and node modules
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
  --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential curl libpq-dev node-gyp pkg-config python-is-python3


FROM prebuild as node

# Install Node.js
ARG NODE_VERSION=21.2.0
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  rm -rf /tmp/node-build-master

# Install node modules
COPY --link package.json ./
RUN --mount=type=cache,id=bld-npm-cache,target=/root/.npm \
  npm install

FROM prebuild as build

# Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN --mount=type=cache,id=bld-gem-cache,sharing=locked,target=/srv/vendor \
  bundle config set app_config .bundle && \
  bundle config set path /srv/vendor && \
  bundle install && \
  bundle exec bootsnap precompile --gemfile && \
  bundle clean && \
  mkdir -p vendor && \
  bundle config set path vendor && \
  cp -ar /srv/vendor .

# Copy node modules
COPY --from=node /rails/node_modules /rails/node_modules
COPY --from=node /usr/local/node /usr/local/node
ENV PATH=/usr/local/node/bin:$PATH

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# We need to run precompile twice so Propshaft sees the newly compiled assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Use dummy Datadog API Key to complete installation
ARG DD_API_KEY="123" \
  DD_AGENT_MAJOR_VERSION="7" \
  DD_INSTALL_ONLY="true" \
  DD_AGENT_FLAVOR="datadog-agent"

# Install packages needed for deployment
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
  --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl postgresql-client ruby-foreman sudo unzip

# Import Tailscale binary
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/bin/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Install the Datadog Agent & Dogstatsd packages
RUN curl -sS -L "https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh" | bash
RUN mkdir -p /etc/datadog-agent && \
  touch /etc/datadog-agent/datadog.yaml

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
  useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
  sed -i 's/env_reset/env_keep="*"/' /etc/sudoers && \
  echo "rails ALL=(ALL) NOPASSWD: /usr/bin/tailscaled" >> /etc/sudoers && \
  echo "rails ALL=(ALL) NOPASSWD: /usr/bin/tailscale" >> /etc/sudoers && \
  echo "rails ALL=(ALL) NOPASSWD: /opt/datadog-agent/bin/agent/agent*" >> /etc/sudoers && \
  echo "rails ALL=(ALL) NOPASSWD: /opt/datadog-agent/embedded/bin/trace-agent*" >> /etc/sudoers && \
  echo "rails ALL=(ALL) NOPASSWD: /opt/datadog-agent/embedded/bin/process-agent*" >> /etc/sudoers && \
  chown -R 1000:1000 db log tmp
USER 1000:1000

# Deployment options
ENV RUBY_YJIT_ENABLE="1" \
  DD_HOSTNAME="" \
  DD_TAGS=""

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["foreman", "start", "--procfile=Procfile"]

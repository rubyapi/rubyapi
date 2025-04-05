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

# Install packages needed to build gems
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
  --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential curl libpq-dev pkg-config python-is-python3

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

# Install packages needed for deployment
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
  --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl postgresql-client ruby-foreman sudo unzip

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
  useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
  sed -i 's/env_reset/env_keep="*"/' /etc/sudoers && \
  chown -R 1000:1000 db log tmp
USER 1000:1000

# Deployment options
ENV RUBY_YJIT_ENABLE="1"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["foreman", "start", "--procfile=Procfile"]

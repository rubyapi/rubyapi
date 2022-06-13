source "https://rubygems.org"

ruby "~> 3.0"

gem "rails", "~> 7.0.2"
gem "bootsnap", ">= 1.1.0", require: false
gem "redis"
gem "puma"
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "propshaft"
gem "pg"

gem "elasticsearch-persistence"

gem "http"
gem "typhoeus", require: false
gem "kaminari", "~> 1.2.2"
gem "inline_svg"
gem "tty-spinner", require: false
gem "skylight", group: :production
gem "graphql"
gem "graphiql-rails", group: :development
gem "lograge"
gem "logstash-event"
gem "aws-sdk-s3"
gem "sitemap_generator"
gem "meta-tags"
gem "sentry-ruby"
gem "sentry-rails"
gem "rack-attack"
gem "rdoc", require: false
gem "trenni-sanitize", require: false
gem "pastel", require: false
gem "rouge", require: false
gem "rbs", require: false
gem "stimulus_reflex", "= 3.5.0.pre9"
gem "anyway_config"
gem "slim"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.8"
  gem "standard"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "webmock"
end

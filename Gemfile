source "https://rubygems.org"

ruby "~> 3.0"

gem "rails", "~> 7.0.5"
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
gem "lograge"
gem "logstash-event"
gem "aws-sdk-s3"
gem "sitemap_generator"
gem "meta-tags"
gem "rack-attack"
gem "rdoc", require: false
gem "trenni-sanitize", require: false
gem "pastel", require: false
gem "rouge", require: false
gem "rbs", require: false
gem "anyway_config"
gem "dry-struct"
gem "view_component"
gem "dogstatsd-ruby"

group :development, :test do
  gem "debug"
  gem "dotenv-rails"
  gem "factory_bot"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.9"
  gem "standard"
  gem "standard-rails"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "webmock"
end

group :production do
  gem "ddtrace", require: "ddtrace/auto_instrument"
end

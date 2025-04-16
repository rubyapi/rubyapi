source "https://rubygems.org"

ruby "~> 3.0"

gem "bootsnap", require: false
gem "pg"
gem "propshaft"
gem "puma"
gem "rails"
gem "solid_cache"
gem "solid_queue"
gem "strong_migrations"
gem "thruster", require: false

gem "opensearch-ruby"
gem "searchkick"

gem "anyway_config"
gem "aws-sdk-core"
gem "dogstatsd-ruby"
gem "http"
gem "importmap-rails"
gem "inline_svg"
gem "lograge"
gem "logstash-event"
gem "meta-tags"
gem "pastel", require: false
gem "rbs", require: false
gem "rdoc", require: false
gem "rouge", require: false
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "trenni-sanitize", require: false
gem "tty-spinner", require: false
gem "typhoeus"
gem "view_component"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "dockerfile-rails"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "vcr"
  gem "webmock"
end

group :production do
  gem "ddtrace", require: "ddtrace/auto_instrument"
end

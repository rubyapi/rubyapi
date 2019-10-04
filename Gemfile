source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.0"
# Use Falcon as the app server
gem "puma"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.1"
gem "hiredis"

gem "elasticsearch-persistence"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false
# HTTP library
gem "http"
# Persistent HTTP connections
gem "typhoeus"
# Pagination
gem "kaminari", "~> 1.1.1"
# Inline SVGs
gem "inline_svg"
# CLI Progress Bar
gem "tty-spinner"
# Proformance tracking
gem "skylight", group: :production
# Template Engine
gem "slim"
# Web API
gem "graphql"
gem "graphiql-rails", group: :development
# Logging
gem "lograge"
gem "logstash-event"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Dotfile configuration
  gem "dotenv-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.3"
  # linting
  gem "standard"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

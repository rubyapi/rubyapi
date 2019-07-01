source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.3"
# Use postgresql as the database for Active Record
gem "pg"
# Use Falcon as the app server
gem "puma"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.1"
gem "hiredis"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false
# HTTP library
gem "http"
# Persistent HTTP connections
gem "typhoeus"
# ElasticSearch Client
gem "searchkick"
# Fast JSON serialization
gem "fast_jsonapi"
gem "oj"
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
gem 'graphiql-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Dotfile configuration
  gem "dotenv-rails", require: "dotenv/rails-now"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # linting
  gem "standard"
  # pretty exceptions
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

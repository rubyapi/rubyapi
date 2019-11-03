source "https://rubygems.org"

ruby "2.6.3"

gem "rails", "~> 6.0.0"
gem "bootsnap", ">= 1.1.0", require: false
gem "puma"
gem "webpacker", "~> 4.0"
gem "redis", "~> 4.1"
gem "hiredis"

gem "elasticsearch-persistence"

gem "http"
gem "typhoeus"
gem "kaminari", "~> 1.1.1"
gem "inline_svg"
gem "tty-spinner"
gem "skylight", group: :production
gem "slim"
gem "graphql"
gem "graphiql-rails", group: :development
gem "lograge"
gem "logstash-event"
gem "aws-sdk-s3"
gem "sitemap_generator"
gem "meta-tags"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.3"
  gem "standard"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

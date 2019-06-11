# Ruby API: Easily search and find Ruby documentation

Ruby API is a Ruby on Rails application that consumes Ruby's documentation and makes it easy for developers to search and explore documentation for Ruby.

## Why?

Trying to find documentation about that one method or class that your wondering about is much harder that it should be for developers. The current goto documentation sites for Ruby like http://ruby-doc.org and http://docs.ruby-lang.org do not optimise for SEO or mobile devices, resulting in a poor experience for users. Other applications that index Ruby's documentation such as Dash, while a much better experience, is a paid application (for the full experience) and is only available on a limited set of devices.

Our mission aims to improve the Ruby ecosystem by providing an application that is:

  * Available to any device with a web browser
  * Provides documentation for all supported versions of Ruby
  * Designed for many different device types
  * Optimized search results for common Ruby classes/methods
  * Optimized SEO to allow Google to understand how to index Ruby's documentation.
  * No ads. No paywall. ever.

## Getting started

Install dependencies:

    $ bundle install && yarn install --check-files

Start services such as Postgresql and ElasticSearch:

    $ docker-compose up -d

Start rails server

    $ bundle exec rake db:setup

## Importing Documentation

Documentation can be imported very easily. There is a rake task that will let you import documentation for a given version:

    $ rake import:ruby[2.6.2]

## Running tests

Tests are written with minitest and can be executed with:

    $ rake test

## Code Of Conduct

Everyone interacting with the source code, issue trackers, chat rooms, and mailing lists is expected to follow the [Code Of Conduct](https://github.com/colby-swandale/ruby-api/blob/master/CODE_OF_CONDUCT.md)

## License

Ruby API is licensed under the [MIT license](https://github.com/colby-swandale/ruby-api/blob/master/LICENSE.md).

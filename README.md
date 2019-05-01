# RubyAPI: Easily search and find Ruby documentation

RubyAPI is a Rails application that consumes Ruby's documentation and makes it easy for developers to find and explore Ruby's documentation.

## Why?

Trying to find documentation about that one method or class that you're currently thinking about is much harder that it should be for developers. Ruby documentation sites like http://ruby-doc.org and http://docs.ruby-lang.org do not optimise for SEO or mobile devices resulting in a poor experience for users. Other applications that index Ruby's documentation such as Dash, while a much better experience, is a paid application (for the full experience) and is only available on limited devices.

Our mission aims to improve the ruby ecosystem by providing an application that can:

  * No ads. No paywall. ever.
  * Available to any device with a web browser
  * Provide documentation for all supported versions of Ruby
  * Optimize the page for displaying documentation on many different types of devices
  * Optimize searching for common Ruby classes/methods
  * Optimize SEO to allow Google to understand how to index developer documentation.

## Getting started

Install dependencies:

    $ bundle install && yarn install --check-files

Start services:

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

RubyAPI is licensed under the [MIT license](https://github.com/colby-swandale/ruby-api/blob/master/LICENSE.md).

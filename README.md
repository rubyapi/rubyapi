[![View performance data on Skylight](https://badges.skylight.io/status/k1noEyWLdXuJ.svg)](https://oss.skylight.io/app/applications/k1noEyWLdXuJ)
[![Travis CI status](https://travis-ci.com/colby-swandale/ruby-api.svg?branch=master)](https://travis-ci.com/colby-swandale/ruby-api)

# Ruby API: Easily search and find Ruby documentation

Ruby API is a Ruby on Rails that makes searching and browsing Ruby's documentation fast and smooth for users.

## Why?

Trying to find documentation about that one method or class that you're looking for can be pretty tedious. The current goto places for Ruby documentation, [ruby-doc.org](https://ruby-doc.org) & [docs.ruby-lang.org](http://docs.ruby-lang.org) are not built with SEO or the many different types of devices used in mind, and result in a poor experience for many users. Other applications that index Ruby's documentation such as Dash, while a much better experience, is a paid application (for the full experience) and is only available on MacOS & iOS.

Our mission aims to improve the Ruby ecosystem by providing an application that is:

  * Available to any device with a web browser
  * Provides documentation for all supported versions of Ruby
  * Designed for many different device types
  * Optimised for searching common Ruby classes/methods
  * Optimised for Google/Search engines to understand how to index Ruby's documentation.
  * Free. No ads. No paywall. ever.

## Getting started

Install dependencies:

    $ bundle install && yarn install

Start services such as Postgresql and ElasticSearch:

    $ docker-compose up -d

Start rails server

    $ ./bin/rake db:setup

## Importing Documentation

Ruby's documentation can be imported very easily. There's a rake task that will let you import a given versions' documentation:

    $ ./bin/rake import:ruby[2.6.2]

## Running tests

Tests are written with Minitest and can be executed with:

    $ ./bin/rake test

## Code Of Conduct

Everyone interacting with the source code, issue trackers, chat rooms, and mailing lists is expected to follow the [Code Of Conduct](https://github.com/colby-swandale/ruby-api/blob/master/CODE_OF_CONDUCT.md)

## License

Ruby API is licensed under the [MIT license](https://github.com/colby-swandale/ruby-api/blob/master/LICENSE.md).

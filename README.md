# Ruby API: Easily Find Ruby documentation 

[![View performance data on Skylight](https://badges.skylight.io/status/k1noEyWLdXuJ.svg)](https://oss.skylight.io/app/applications/k1noEyWLdXuJ) 

Ruby API is a Ruby on Rails app that makes browsing and searching Ruby's documentation easy and fast for users.

## Why?

Trying to find documentation about that one Ruby method or class you're looking for can be pretty tedious. The current goto places for Ruby documentation - [ruby-doc.org](https://ruby-doc.org) & [docs.ruby-lang.org](http://docs.ruby-lang.org) offer only basic searching and are not designed for mobile devices. Other apps for searching Ruby's documentation such as Dash, while a much better experience, is a paid application (for the full experience) and is only available on devices running MacOS & iOS.

Ruby API aims to improve the Ruby ecosystem by providing an application that is:

  * Available to any device with a web browser and internet connection
  * Designed for mobile devices in mind
  * Optimised for searching common Ruby classes/methods
  * Optimised for Google/Search engines to understand how to index Ruby's documentation.
  * Free. No ads. ever.

## Getting started

Install dependencies:

    $ bundle install && yarn install

Start ElasticSearch:

    $ docker-compose up -d

Start the Rails Server

    $ ./bin/rails server

Optionally, you also may want to start the webpack dev server

    $ ./bin/webpack

## Importing Documentation

Ruby's documentation can be imported very easily. There's a rake task that will let you import a given versions' documentation:

    $ ./bin/rake import:ruby[2.6.4]

## Running tests

The test suite can be executed with:

    $ ./bin/rake test

## Code Of Conduct

Everyone interacting with the source code, issue trackers, chat rooms, and mailing lists is expected to follow the [Code Of Conduct](https://github.com/rubyapi/rubyapi/blob/master/CODE_OF_CONDUCT.md)

## License

Ruby API is licensed under the [MIT license](https://github.com/rubyapi/rubyapi/blob/master/LICENSE.md).

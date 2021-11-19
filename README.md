# Ruby API: Easily Find Ruby documentation

[![View performance data on Skylight](https://badges.skylight.io/status/k1noEyWLdXuJ.svg)](https://oss.skylight.io/app/applications/k1noEyWLdXuJ)
[![CI](https://github.com/rubyapi/rubyapi/workflows/CI/badge.svg?branch=master)](https://github.com/rubyapi/rubyapi/actions?query=workflow%3ACI+branch%3Amaster)

Ruby API makes it easy and fast to search or browse the Ruby language API docs.

## Why?

The existing websites for Ruby documentation are hard to search, and impossible to read on mobile devices. Ruby API provides instant search results, inspired by [Dash](http://kapeli.com/dash), and a responsive design that's easy to read on any size device.

We aim to improve the Ruby ecosystem by being:

* Readable on any size device
* Fast on any speed internet connection
* Relevant search results that surface useful APIs
* Search engine optimized pages for every API method
* Free, with no ads. Ever.

## Getting started

Install dependencies:

```sh
$ ./bin/setup
```

Start ElasticSearch:

```sh
$ docker compose up -d
```

Start the Rails Server

```sh
$ ./bin/rails server
```

Optionally, you also may want to start the webpack dev server

```sh
$ ./bin/webpack-dev-server
```

## Importing Documentation

Ruby's documentation can be imported very easily. There's a rake task that will let you import a given versions' documentation:

```sh
$ ./bin/rake import:ruby[3.0.0]
```

or you can easily import the latest versions of all currently supported versions of ruby:

```sh
$ ./bin/rake import:ruby:all
```

## Running tests

The test suite can be executed with:

```sh
$ ./bin/rake test
```

## Linting code

This project uses [StandardRB](https://github.com/testdouble/standard) for linting.

StandardRB can be executed with:

```sh
$ ./bin/standardrb
```

_Note: This command may make changes to your code, to make it conform to the formatting rules of
this project._

For instructions on running StandardRB in your editor, [check out StandardRB's Documentation](https://github.com/testdouble/standard#how-do-i-run-standard-in-my-editor).

## Code Of Conduct

Everyone interacting with the source code, issue trackers, chat rooms, and mailing lists is expected to follow the [Code Of Conduct](https://github.com/rubyapi/rubyapi/blob/master/CODE_OF_CONDUCT.md)

## License

Ruby API is licensed under the [MIT license](https://github.com/rubyapi/rubyapi/blob/master/LICENSE.md).

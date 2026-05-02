# Ruby API: Easily Find Ruby documentation

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

### Github Dev Container

For a quick, easy and automated way to get started, you can use the [Github Dev Container](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/introduction-to-dev-containers).

Github Dev Containers will automatically install all the dependencies and start the application.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=165846166&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=EastUs)

### Local Machine

Install dependencies:

_Note: This command can also be used to quickly update the application dependencies_

```sh
bin/setup
```

Start ElasticSearch:

```sh
docker compose up -d
```

<details>
<summary>Alternatives to Docker</summary>

We only officially support Docker, but you can try with [Podman](https://podman.io) instead:

```sh
podman-compose up -d
```
</details>

Start the Rails Server

```sh
bin/dev
```

## Importing Documentation

Ruby's documentation can be imported very easily. There's a rake task that will let you import a given versions' documentation:

```sh
bin/rails import:ruby[3.1]
```

or you can easily import the latest versions of all currently supported versions of Ruby:

```sh
bin/rails import:ruby:all
```

## Running tests

The test suite can be executed with:

```sh
bin/rails test
```

## Linting code

This project uses [StandardRB](https://github.com/standardrb/standard) for linting.

StandardRB can be executed with:

```sh
bin/standardrb
```

_Note: This command may make changes to your code, to make it conform to the formatting rules of
this project._

For instructions on running StandardRB in your editor, [check out StandardRB's Documentation](https://github.com/testdouble/standard#how-do-i-run-standard-in-my-editor).


## Sponsorship

<a href="https://rubycentral.org/"><img src="https://rubycentral.org/content/images/size/w256h256/format/png/2022/11/Ruby-Central-logo.svg" height=110></a><br/>

[rubyapi.org](https://rubyapi.org) is supported by [Ruby Central](https://rubycentral.org), a non-profit organization that supports the Ruby community through projects like this one, as well as [RubyGems.org](https://rubygems.org), [RubyConf](https://rubyconf.org), [RailsConf](https://railsconf.org), and [Bundler](https://bundler.io). You can support Ruby Central by attending or [sponsoring](sponsors@rubycentral.org) a conference, or by [joining as a supporting member](https://rubycentral.org/#/portal/signup).

Hosting is donated by [Amazon Web Services](https://aws.amazon.com), with CDN service donated by [Fastly](https://fastly.com).

[Learn more about our sponsors and how they work together.](https://rubygems.org/pages/sponsors)

## Code Of Conduct

Everyone interacting with the source code, issue trackers, chat rooms, and mailing lists is expected to follow the [Code Of Conduct](https://github.com/rubyapi/rubyapi/blob/master/CODE_OF_CONDUCT.md)

## License

Ruby API is licensed under the [MIT license](https://github.com/rubyapi/rubyapi/blob/master/LICENSE.md).

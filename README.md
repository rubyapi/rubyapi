# Ruby API: Easily Find Ruby documentation

A fast, mobile-friendly documentation browser for Ruby and the Ruby standard library. Live at [rubyapi.org](https://rubyapi.org).

## Why?

The existing Ruby docs sites are hard to search and uncomfortable to read on a phone, which is where a lot of us actually look up docs. RubyAPI's job is to fix that: instant search, pages small enough to load over a slow connection, and layouts that work the same on a phone as on a laptop. It's free, supported by Ruby Central, and there are no ads.

The search experience is inspired by [Dash](https://kapeli.com/dash). Documentation is imported directly from the official Ruby source via RDoc and indexed in OpenSearch.

We aim to improve the Ruby ecosystem by being:

* Readable on any size device
* Fast on any speed internet connection
* Relevant search results that surface useful APIs
* Search engine optimized pages for every API method
* Free, with no ads. Ever.

## Getting started

The fastest way to try the project is GitHub Codespaces, which boots a fully configured environment in one click:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=165846166&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=EastUs)

To run locally, you need Ruby 4 and Docker. PostgreSQL and OpenSearch run in containers. Then:

```sh
bin/setup            # install gems, copy database.yml, prepare the database
docker compose up -d # start PostgreSQL and OpenSearch
bin/dev              # start the Rails server on port 3000
```

`bin/setup` is also what you run when you pull updates: it refreshes gems and applies new migrations.

<details>
<summary>Alternatives to Docker</summary>

Docker is the only setup we officially support, but [Podman](https://podman.io) tends to work fine if you already use it:

```sh
podman-compose up -d
```
</details>

## Importing documentation

Pull docs for a single Ruby version:

```sh
bin/rails import:ruby[4.0]
```

Or every currently supported version at once:

```sh
bin/rails import:ruby:all
```

## Running tests

```sh
bin/rails test
```

Tests hit a real database, so PostgreSQL and OpenSearch both need to be running.

## Linting code

[RuboCop](https://github.com/rubocop/rubocop) is the linter. Run it to see violations, or pass `-a` to autocorrect what it can:

```sh
bin/rubocop
bin/rubocop -a
```

## Sponsorship

<a href="https://rubycentral.org/"><img src="https://rubycentral.org/content/images/size/w256h256/format/png/2022/11/Ruby-Central-logo.svg" height=110></a>

[rubyapi.org](https://rubyapi.org) is supported by [Ruby Central](https://rubycentral.org), a non-profit that funds Ruby community infrastructure including [RubyGems.org](https://rubygems.org), [RubyConf](https://rubyconf.org), [RailsConf](https://railsconf.org), and [Bundler](https://bundler.io). You can support Ruby Central by attending or [sponsoring a conference](mailto:sponsors@rubycentral.org), or by [joining as a supporting member](https://rubycentral.org/#/portal/signup).

Hosting is donated by [Amazon Web Services](https://aws.amazon.com), and CDN service is donated by [Fastly](https://fastly.com). [More about our sponsors.](https://rubygems.org/pages/sponsors)

## Code Of Conduct

Everyone interacting with the source code, issue trackers, and chat rooms is expected to follow the [Code of Conduct](https://github.com/rubyapi/rubyapi/blob/main/CODE_OF_CONDUCT.md).

## License

MIT. See [LICENSE.md](https://github.com/rubyapi/rubyapi/blob/main/LICENSE.md).

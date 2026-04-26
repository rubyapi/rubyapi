# RubyAPI

A fast, mobile-friendly documentation browser for the Ruby standard library and Ruby itself. Imports the official Ruby source via RDoc, indexes the result in OpenSearch, and serves polished, search-driven pages for developers who arrive mid-task and need an answer in seconds.

## Commands

- `bin/setup` — install deps, copy `database.yml.sample`, prepare DB, start dev server
- `bin/dev` — start the Rails dev server on port 3000
- `bin/rails test` — run tests (Minitest, fixtures-based; requires PostgreSQL + OpenSearch)
- `bin/rails test path/to/test_file.rb` — run a single test file
- `bin/rubocop` — lint with RuboCop (rubocop-rails-omakase config)
- `bin/ci` — full CI suite (rubocop, bundler-audit, importmap audit, brakeman, tests, seed replant)
- `bin/rails import:ruby[3.4]` — import documentation for a specific Ruby version
- `docker compose up -d` — start PostgreSQL 17 + OpenSearch 2.11. Canonical local setup; running them via Homebrew services also works if you already do that.

## Architecture

- **Rails 8.1** (Ruby 3.4.2) — no ActionMailer, ActionCable, ActiveStorage, or ActionText
- **Database:** PostgreSQL with 3 logical databases (primary, cache via SolidCache, queue via SolidQueue). Migrations: `db/migrate/`, `db/cache_migrate/`, `db/queue_migrate/`
- **Search:** OpenSearch via Searchkick. Indexed models: `RubyObject`, `RubyMethod`, `RubyConstant`
- **Background jobs:** SolidQueue (runs in Puma process in production via `SOLID_QUEUE_IN_PUMA=true`)
- **Assets:** Propshaft + importmap-rails + TailwindCSS (tailwindcss-rails)
- **Frontend:** Stimulus controllers, no React/Vue
- **Config:** `anyway_config` gem, config classes in `config/configs/`, YAML in `config/ruby.yml` and `config/theme.yml`
- **Deployment:** Kamal to AWS ECR. Production uses Thruster (HTTP/2, asset caching) wrapping Puma

## Key Models

- `RubyRelease` — version records for each Ruby release
- `RubyObject` — classes/modules, polymorphic via `documentable` association to `RubyRelease`
- `RubyMethod`, `RubyConstant`, `RubyAttribute`, `RubyPage` — belong to `RubyObject`

## Documentation Import Pipeline

Entry point: `bin/rails import:ruby[<version>]` (e.g. `import:ruby[3.4]`). All code lives in `lib/`:

1. `RubyDownloader` — fetches and extracts the Ruby source tarball for the target `RubyRelease`.
2. `RubyDocumentationImporter` — orchestrator. Calls the downloader, then runs RDoc against the extracted source with `RubyAPIRDocGenerator` as a custom generator. Wrapped in a transaction that wipes prior records for that release.
3. `RubyAPIRDocGenerator` (`lib/rubyapi_rdoc_generator.rb`) — writes the parsed RDoc tree into `RubyObject` / `RubyMethod` / `RubyConstant` / `RubyAttribute` / `RubyPage` records.

## Gotchas

- `config/database.yml` is **not committed** — `bin/setup` copies from `config/database.yml.sample`
- **OpenSearch & PostgreSQL must be running for tests** — Rails tests hit a real DB, and `test_helper.rb` reindexes searchable models in setup before disabling Searchkick callbacks
- `Current` thread-local state (`Current.theme`, `Current.ruby_release`, `Current.default_ruby_release`) is set per-request
- RuboCop config lives in `.rubocop.yml` (inherits from `rubocop-rails-omakase`); use `bin/rubocop -a` to autocorrect
- Routes use optional `(:version)` parameter matching `X.Y` or `dev`
- `RubyObject` uses `callbacks: :async` for Searchkick, so index updates go through SolidQueue

## Environment Variables

- `OPENSEARCH_URL` — OpenSearch connection
- `DATABASE_URL`, `CACHE_DATABASE_URL`, `QUEUE_DATABASE_URL` — PostgreSQL connections
- `RAILS_MASTER_KEY` — credentials decryption
- `SOLID_QUEUE_IN_PUMA` — run SolidQueue in Puma process (production)

## Design Context

### Users
Ruby developers across all experience levels — from beginners learning the standard library to experts looking up a specific method signature. Primary context: they arrive with intent, often mid-task, and need to find and read an API in seconds. Frequently on mobile or a slow connection. The existing Ruby docs ecosystem (ruby-doc.org, legacy RDoc output) is the baseline this project exists to improve on.

### Brand Personality
Technical but polished. Three words: **precise, calm, crafted**. The interface should feel like a serious developer tool — quietly confident, fast, and considered — not loud, not marketing-y, not chatty. The Ruby-red accent (`#e1175a`) anchors identity, but expression comes from typography, spacing, and restraint rather than decoration.

### Aesthetic Direction
Refined technical. Crisp type, a tight and consistent spacing scale, subtle depth where it aids scanability, and generous room for prose and code to breathe. Light + dark + system themes are first-class; both must feel native, not like one is an afterthought. Code samples are prominent and carry a distinct, legible palette.

**References (aim for this feel):** MDN, Stripe docs (typography, structure, technical clarity); Dash / DevDocs (speed, keyboard-driven, instant search).

**Anti-references (do not look like):** legacy ruby-doc.org / raw RDoc output (dated, hard to scan, poor on mobile); marketing/SaaS landing pages (hero gradients, stock illustrations, flashy animation).

### Design Principles
1. **Content leads, chrome recedes.** Docs are the product. UI earns its pixels by making docs easier to find, scan, or read — otherwise it disappears.
2. **Fast perceptually, not just technically.** Layouts must not jank on load; interactions should feel instant. Prefer small, cache-friendly pages over clever spinners.
3. **Mobile and desktop are equal first-class surfaces.** Every change gets checked at narrow widths. Touch targets, readable line lengths, and reachable controls are non-negotiable.
4. **Light and dark parity.** Both themes get the same polish. No mode should ship with lower-contrast type, misaligned borders, or unreadable code colors.
5. **WCAG 2.1 AA, reduced-motion aware.** AA contrast in both themes, keyboard navigation, proper semantics and labels, respect `prefers-reduced-motion`. Motion is opt-in utility, never decoration.
6. **Restraint over flourish.** When a decision is close, pick the quieter option. New visual ideas need a reason tied to a user task, not novelty.

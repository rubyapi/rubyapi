require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # default ruby version documentation
    config.default_ruby_version = '3.1'

    config.ruby_versions = %w[
      3.1 3.0 2.7 2.6 2.5 2.4 2.3 dev
    ]

    config.eol_ruby_versions = %w[2.5 2.4 2.3]

    config.elasticsearch_shards = ENV.fetch('ELASTICSEARCH_SHARDS', 5).to_i
    config.elasticsearch_replicas = ENV.fetch('ELASTICSEARCH_REPLICAS', 1).to_i
    config.repl_host = ENV.fetch('REPL_HOST', '')
    config.repl_api_key = ENV.fetch('REPL_API_KEY', '')
  end
end

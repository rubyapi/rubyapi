# frozen_string_literal: true

require_relative 'boot'

require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'
require 'active_support/core_ext'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

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

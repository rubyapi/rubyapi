# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

Rails.root.glob("lib/*.rb").each { |f| require_relative f }
Rails.root.glob("test/factories/*.rb").each { |f| require_relative f }

WebMock.disable!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)
  #

  fixtures :all

  def setup
    Current.theme = ThemeConfig.theme_for("light")
    Current.ruby_release = ruby_releases(:latest)
    Current.default_ruby_release = ruby_releases(:latest)

    # reindex models
    RubyObject.reindex
    RubyMethod.reindex
    RubyConstant.reindex

    # and disable callbacks
    Searchkick.disable_callbacks
  end

  def default_ruby_release
    ruby_releases(:latest)
  end
end

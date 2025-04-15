# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

WebMock.disable!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  fixtures :all

  parallelize_setup do |worker|
    Searchkick.index_suffix = worker

    RubyObject.reindex
    RubyMethod.reindex
    RubyConstant.reindex

    Searchkick.disable_callbacks
  end

  def setup
    Current.theme = ThemeConfig.theme_for("light")
    Current.ruby_version = ruby_version(:latest)
    Current.default_ruby_version = ruby_version(:latest)
  end
end

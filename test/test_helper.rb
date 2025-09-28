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
  end

  # Add more helper methods to be used by all tests here...
  def create_index_for_release!(release)
    search_repository(release).create_index! force: true
    ruby_object_repository(release).create_index! force: true
  end

  def default_ruby_release
    ruby_releases(:latest)
  end

  def bulk_index_search(objects, release: nil, wait_for_refresh: false)
    search_repository(release).bulk_import(objects, wait_for_refresh: wait_for_refresh)
  end

  def index_search(object, release: nil)
    search_repository(release).save object
  end

  def index_object(object, release: nil)
    ruby_object_repository(release).save object
  end

  def search_repository(release = nil)
    release ||= default_ruby_release
    SearchRepository.repository_for_release(release)
  end

  def ruby_object_repository(release = nil)
    release ||= default_ruby_release
    RubyObjectRepository.repository_for_release(release)
  end
end

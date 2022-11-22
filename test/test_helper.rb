# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

Dir.glob(Rails.root.join("lib/*.rb")).each { |f| require_relative f }
Dir.glob(Rails.root.join("test/factories/*.rb")).each { |f| require_relative f }

WebMock.disable!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  def setup
    Current.ruby_version = FactoryBot.build(:ruby_version, version: "3.1", default: true)
    Current.default_ruby_version = FactoryBot.build(:ruby_version, version: "3.1", default: true)
  end

  # Add more helper methods to be used by all tests here...
  def create_index_for_version!(version)
    search_repository(version).create_index! force: true
    ruby_object_repository(version).create_index! force: true
  end

  def default_ruby_version
    RubyConfig.default_ruby_version.version
  end

  def bulk_index_search(objects, version: nil, wait_for_refresh: false)
    search_repository(version).bulk_import(objects, wait_for_refresh: wait_for_refresh)
  end

  def index_search(object, version: nil)
    search_repository(version).save object
  end

  def index_object(object, version: nil)
    ruby_object_repository(version).save object
  end

  def search_repository(version = nil)
    version ||= default_ruby_version
    SearchRepository.repository_for_version(version)
  end

  def ruby_object_repository(version = nil)
    version ||= default_ruby_version
    RubyObjectRepository.repository_for_version(version)
  end
end

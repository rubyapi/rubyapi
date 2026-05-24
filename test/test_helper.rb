# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

Rails.root.glob("lib/*.rb").each { |f| require_relative f }

WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    Searchkick.index_suffix = "test-worker-#{worker}"
  end

  fixtures :all

  SEARCH_MODELS = [ RubyObject, RubyMethod, RubyConstant ].freeze

  def reindex_search_models
    SEARCH_MODELS.each(&:reindex)
    Searchkick.disable_callbacks
  end

  def delete_search_index
    SEARCH_MODELS.each do |model|
      model.search_index.delete
    end
  end
end

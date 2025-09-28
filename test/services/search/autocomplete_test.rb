# frozen_string_literal: true

require "test_helper"

class Search::AutocompleteTest < ActiveSupport::TestCase
  def setup
    create_index_for_release! default_ruby_release

    method = FactoryBot.build :ruby_method, name: "foo"

    objects = [String, Array, Integer, Symbol, Hash].map { |klass| FactoryBot.build(:ruby_object, c: klass, ruby_methods: [method]) }
    bulk_index_search objects, release: default_ruby_release, wait_for_refresh: true
  end

  test "search for a method" do
    search = Search::Autocomplete.search "foo", release: default_ruby_release
    assert_equal 5, search.results.size
  end
end

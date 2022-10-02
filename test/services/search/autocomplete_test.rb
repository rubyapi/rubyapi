# frozen_string_literal: true

require "test_helper"

class Search::AutocompleteTest < ActiveSupport::TestCase
  def setup
    create_index_for_version! "3.1"

    @objects = []
    [String, Array, Hash, Integer, Float, Symbol].each do |klass|
      @objects << FactoryBot.build(:search_result, :method, c: klass )
    end

    @objects.each { |o| index_search(o, version: "3.1") }
  end

  test "search for a method" do
    search = Search::Autocomplete.search "to_s", version: "3.1"
    assert_equal 5, search.results.size
  end
end

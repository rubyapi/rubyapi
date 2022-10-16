# frozen_string_literal: true

require "test_helper"

class AutocompleteControllerTest < ActionDispatch::IntegrationTest
  def setup
    create_index_for_version! default_ruby_version

    objects = [String, Array, Integer, Symbol, Hash].map { |klass| ruby_object(klass) }
    bulk_index_search objects, version: default_ruby_version, wait_for_refresh: true
  end

  test "should get index" do
    get autocomplete_path(q: "new")
    assert_response :success
  end

  test "should render results" do
    get autocomplete_path(q: "to_i")
    assert_equal 5, response.parsed_body.length
  end

  test "should cache responses" do
    get autocomplete_path(q: "view")
    assert_equal response.headers["Cache-Control"], "max-age=86400, public"
  end

  test "should render empty array when no query is given" do
    get autocomplete_path(q: "")
    assert_equal [], response.parsed_body
  end
end

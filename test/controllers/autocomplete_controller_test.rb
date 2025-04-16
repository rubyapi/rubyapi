# frozen_string_literal: true

require "test_helper"

class AutocompleteControllerTest < ActionDispatch::IntegrationTest
  def setup
    @string = ruby_object(:string)

    [ RubyMethod, RubyObject, RubyConstant ].each { it.reindex }
  end

  test "should get index" do
    get autocomplete_path(q: "new")
    assert_response :success
  end

  test "should render results" do
    get autocomplete_path(q: "new")
    assert_equal 1, response.parsed_body.length
  end

  test "should cache responses" do
    get autocomplete_path(q: "new")
    assert_equal response.headers["Cache-Control"], "max-age=86400, public"
  end

  test "should render empty array when no query is given" do
    get autocomplete_path(q: "")
    assert_equal [], response.parsed_body
  end
end

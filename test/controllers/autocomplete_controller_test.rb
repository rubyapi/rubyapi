# frozen_string_literal: true

require "test_helper"

class AutocompleteControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get autocomplete_path(q: "new")
    assert_response :success
  end

  test "should render results" do
    get autocomplete_path(q: "new")
    assert response.parsed_body.size > 1
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

# frozen_string_literal: true

require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  def setup
    create_index_for_release! default_ruby_release

    string = FactoryBot.build(:ruby_object)
    index_search string
  end

  test "should get index" do
    get search_url params: {q: "test"}
    assert_response :success
  end

  test "redirect when no search param given" do
    get search_url
    assert_redirected_to root_url
  end

  test "max query length" do
    get search_url, params: {q: ("a" * 255)}

    assert_response :bad_request
  end
end

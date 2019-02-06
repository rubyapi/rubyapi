require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  test "search redirect with no query" do
    get "/s"

    assert_response :redirect

    follow_redirect!

    assert_response :success

    assert_select "h1", "Find & browse Ruby documentation"
  end
end

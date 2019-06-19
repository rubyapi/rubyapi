require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  test "search redirect with no query" do
    get "/o/s"

    assert_response :redirect

    follow_redirect!

    assert_response :success

    assert_select "h2", "Hello World!"
  end
end

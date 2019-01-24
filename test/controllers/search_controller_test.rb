require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  def setup
    Searchkick.enable_callbacks

    ruby_objects(:string).save!
    RubyObject.search_index.refresh
    RubyMethod.search_index.refresh
  end

  def teardown
    Searchkick.disable_callbacks
  end

  test "should get index" do
    get search_url params: { q: "test" }
    assert_response :success
  end

  test "redirect when no search param given" do
    get search_url
    assert_redirected_to root_url
  end
end

# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "feature headers" do
    get root_url

    assert_equal false, response.headers["X-RubyAPI-Signatures"]
    assert_equal "system", response.headers["X-RubyAPI-Theme"]
    assert_equal "X-RubyAPI-Signatures, X-RubyAPI-Theme", response.headers["Vary"]
  end

  test "set theme" do
    post set_theme_path(theme: "light")

    assert_redirected_to root_path
    assert_equal "light", cookies[:theme]
  end

  test "set theme with referer" do
    post set_theme_path(theme: "light"), headers: { "Referer" => "/3.1/object" }

    assert_redirected_to "/3.1/object"
  end

  test "set invalid theme" do
    post set_theme_path(theme: "invalid")

    assert_response :bad_request
  end

  test "should get index" do
    get root_url
    assert_response :success
  end
end

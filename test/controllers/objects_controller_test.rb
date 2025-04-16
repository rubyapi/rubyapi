# frozen_string_literal: true

require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @string = ruby_object(:string)
  end

  test "should get show" do
    get object_url object: @string.path
    assert_response :success
  end

  test "object not found" do
    get object_url object: "invalid"
    assert_response :not_found
  end

  test "show method sequence" do
    get object_url object: @string.path

    assert_select "h4", "to_s → self or string"
  end

  test "show method type signature" do
    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", "(?::int base) -> ::Integer"
  end

  test "show method type signature with RubyAPI Feature header" do
    get object_url(object: @string.path), headers: { "X-RubyAPI-Signatures" => "true" }

    assert_select "h4", "(?::int base) -> ::Integer"
  end

  test "show method name when signatures are enabled" do
    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", "to_s"
  end

  test "set signature cookie" do
    current_object = object_url(object: @string.path)
    post toggle_signatures_path, headers: { "HTTP_REFERER" => current_object }

    assert_response :redirect
    assert_redirected_to current_object

    assert_equal cookies[:signatures], "true", "Signatures should be enabled"
  end

  test "toggle signature without return url" do
    post toggle_signatures_path

    assert_response :redirect
    assert_redirected_to root_path

    assert_equal cookies[:signatures], "true", "Cookie should be set to true"
  end

  test "turn off type signatures" do
    post toggle_signatures_path

    assert_response :redirect
    assert_equal cookies[:signatures], "true", "Signatures should be enabled"

    post toggle_signatures_path

    assert_equal cookies[:signatures], "false", "Signatures should be disabled"
  end
end

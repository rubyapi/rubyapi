# frozen_string_literal: true

require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @string = ruby_objects(:string)
  end

  test "should get show" do
    get object_url object: @string.path
    assert_response :success
  end

  test "object not found" do
    get object_url object: "invalid"
    assert_response :not_found
  end

  test "different ruby version" do
    string = ruby_objects(:string)
    legacy_version = ruby_releases(:legacy)

    string.update(documentable: legacy_version)

    get object_url object: string.path, version: legacy_version.version
    assert_response :success
  end

  test "object not found on different ruby version" do
    get object_url object: "/o/invalid-object", version: ruby_releases(:legacy).version

    assert_response :not_found
  end

  test "show method sequence" do
    get object_url object: @string.path

    assert_select "h4", "str.to_i # => 1"
  end

  test "show method type signature" do
    method = ruby_methods(:to_i)
    method.update(signatures: ["(?::int radix) -> ::Integer"])

    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", "(?::int radix) -> ::Integer"
  end

  test "show method type signature with RubyAPI Feature header" do
    method = ruby_methods(:to_i)
    method.update(signatures: ["(?::int radix) -> ::Integer"])

    get object_url(object: @string.path), headers: {"X-RubyAPI-Signatures" => "true"}

    assert_select "h4", "(?::int radix) -> ::Integer"
  end

  test "show method sequences when signatures are enabled" do
    method = ruby_methods(:to_i)

    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", method.name
  end

  test "multiline call sequence" do
    method = ruby_methods(:to_i)
    method.update(call_sequences: ["foo(a,b)", "foo(arg1, arg2)"])

    get object_url object: @string.path

    assert_select "h4", "foo(a,b)"
    assert_select "h4", "foo(arg1, arg2)"
  end

  test "toggle signature" do
    current_object = object_url(object: @string.path)
    post toggle_signatures_path, headers: {"HTTP_REFERER" => current_object}

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

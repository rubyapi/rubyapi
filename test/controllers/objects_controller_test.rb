# frozen_string_literal: true

require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @string = FactoryBot.build(:ruby_object)
    create_index_for_release! default_ruby_release
    index_object @string
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
    create_index_for_release! ruby_releases(:legacy)

    index_object @string, release: ruby_releases(:legacy)

    get object_url object: @string.path, version: ruby_releases(:legacy).version
    assert_response :success
  end

  test "object not found on different ruby version" do
    other_object = FactoryBot.build(:ruby_object, c: Hash)

    create_index_for_release! ruby_releases(:legacy)

    index_object other_object, release: ruby_releases(:legacy)

    get object_url object: other_object.path, version: default_ruby_release.version

    assert_response :not_found
  end

  test "show method sequence" do
    get object_url object: @string.path

    assert_select "h4", "str.to_i # => 1"
  end

  test "show method type signature" do
    @string.ruby_methods << FactoryBot.build(:ruby_method, name: "signature_test_1", signatures: ["(::String input) -> ::String"])
    index_object @string

    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", "(::String input) -> ::String"
  end

  test "show method type signature with RubyAPI Feature header" do
    @string.ruby_methods << FactoryBot.build(:ruby_method, name: "signature_test_2", signatures: ["(::String input) -> ::Hash"])
    index_object @string

    get object_url(object: @string.path), headers: {"X-RubyAPI-Signatures" => "true"}

    assert_select "h4", "(::String input) -> ::Hash"
  end

  test "show method name when signatures are enabled" do
    @string.ruby_methods << FactoryBot.build(:ruby_method, name: "foo")
    index_object @string

    post toggle_signatures_path

    get object_url object: @string.path

    assert_select "h4", "foo"
  end

  test "multiline call sequence" do
    @string.ruby_methods << FactoryBot.build(
      :ruby_method,
      name: "foo",
      call_sequence: [
        "foo(a,b)",
        "foo(arg1, arg2)"
      ]
    )

    index_object @string

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

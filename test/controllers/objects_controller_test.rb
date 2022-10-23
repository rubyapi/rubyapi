# frozen_string_literal: true

require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @string = FactoryBot.build(:ruby_object)
    create_index_for_version! default_ruby_version
    index_object @string
  end

  test "should get show" do
    get object_url object: @string.path
    assert_response :success
  end

  test "object not found" do
    assert_raises(ActionController::RoutingError) do
      get object_url object: "invalid"
    end
  end

  test "different ruby version" do
    create_index_for_version! "2.5"

    index_object @string, version: "2.5"

    get object_url object: @string.path, version: "2.5"
    assert_response :success
  end

  test "object not found on different ruby version" do
    other_object = FactoryBot.build(:ruby_object, c: Hash)

    create_index_for_version! "2.3"

    index_object other_object, version: "2.3"

    assert_raises(ActionController::RoutingError) do
      get object_url object: other_object.path, verison: default_ruby_version
    end
  end

  test "show method sequence" do
    get object_url object: @string.path

    assert_select "h4", "str.to_i # => 1"
  end

  test "show method name when signatures are enabled" do
    post toggle_signatures_path

    @string.ruby_methods << FactoryBot.build(:ruby_method, name: "foo")
    index_object @string

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

    assert session[:show_signatures]
  end

  test "toggle signature without return url" do
    post toggle_signatures_path

    assert_response :redirect
    assert_redirected_to root_path

    assert session[:show_signatures]
  end

  test "turn off type signatures" do
    post toggle_signatures_path

    assert_response :redirect
    assert session[:show_signatures]

    post toggle_signatures_path

    refute session[:show_signatures]
  end
end

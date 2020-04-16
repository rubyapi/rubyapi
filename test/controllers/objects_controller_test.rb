# frozen_string_literal: true

require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    create_index_for_version! default_ruby_version
  end

  test "should get show" do
    string = ruby_object String
    index_object string

    get object_url object: string.path
    assert_response :success
  end

  test "object not found" do
    get object_url object: "invalid"
    assert_response :not_found
  end

  test "different ruby version" do
    create_index_for_version! "2.5"

    string = ruby_object String
    index_object string, version: "2.5"

    get object_url object: string.path, version: "2.5"
    assert_response :success
  end

  test "object not found on different ruby version" do
    create_index_for_version! "2.3"

    string = ruby_object String
    index_object string, version: "2.3"

    get object_url object: string.path
    assert_response :not_found
  end

  test "show method sequence" do
    string = ruby_object String
    index_object string

    get object_url object: string.path

    assert_select "h4", "str.to_i # => 1"
  end

  test "show method name" do
    string_info = ruby_object(String).to_hash
    string_info[:methods] << {
      name: "foo",
      description: "<h1>Hello World</h1>",
      method_type: "instance_method",
      object_constant: "String",
      superclass: "Object",
      included_modules: [],
      source_location: "2.6.4:string.c:L1",
      call_sequence: []
    }

    string = RubyObject.new(string_info)

    index_object string

    get object_url object: string.path

    assert_select "h4", "foo"
  end
end

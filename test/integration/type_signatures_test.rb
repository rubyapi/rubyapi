# frozen_string_literal: true

require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  def setup
    string_info = ruby_object(String).to_hash

    string_info[:methods] << {
      name: "foo",
      description: "<h1>Hello World</h1>",
      method_type: "class_method",
      object_constant: "String",
      superclass: "Object",
      included_modules: [],
      source_location: "2.6.4:string.c:L1",
      call_sequence: [
        "foo(a,b)",
        "foo(arg1, arg2)"
      ],
      signatures: [
        "(::string other) -> ::Integer",
        "(untyped other) -> ::Integer?"
      ]
    }
    string_info[:methods] << {
      name: "bar",
      description: "<h1>Hello World</h1>",
      method_type: "instance_method",
      object_constant: "String",
      superclass: "Object",
      included_modules: [],
      source_location: "2.6.4:string.c:L3",
      call_sequence: []
    }

    @string = RubyObject.new(string_info)

    index_object @string
  end

  test "turn on type signatures" do
    get object_url object: @string.path

    assert_select "h4", "foo(a,b)"
    assert_select "h4", "foo(arg1, arg2)"

    post toggle_signatures_url, headers: {"HTTP_REFERER" => object_url(object: @string.path)}

    follow_redirect!

    assert_select "h4", "(::string other) -> ::Integer"
    assert_select "h4", "(untyped other) -> ::Integer?"
  end
end

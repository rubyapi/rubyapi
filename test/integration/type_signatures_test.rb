# frozen_string_literal: true

require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  def setup
    @object = ruby_objects(:string)
    @method = ruby_methods(:to_i)
    @method.update(
      call_sequences: [
        "foo(a,b)",
        "foo(arg1, arg2)",
      ],
      signatures: [
        "(::string other) -> ::Integer",
        "(untyped other) -> ::Integer?",
      ]
    )
  end

  test "turn on type signatures" do
    get object_url object: @object.path

    assert_select "h4", "foo(a,b)"
    assert_select "h4", "foo(arg1, arg2)"

    post toggle_signatures_url, headers: {"HTTP_REFERER" => object_url(object: @object.path)}

    follow_redirect!

    assert_select "h4", "(::string other) -> ::Integer"
    assert_select "h4", "(untyped other) -> ::Integer?"
  end
end

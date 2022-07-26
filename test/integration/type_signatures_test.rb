# frozen_string_literal: true

require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  def setup
    @string = FactoryBot.build(:ruby_object)
    @string.ruby_methods << FactoryBot.build(
      :ruby_method, 
      call_sequence: [ 
        "foo(a,b)",
        "foo(arg1, arg2)"
      ],
      signatures: [
        "(::string other) -> ::Integer",
        "(untyped other) -> ::Integer?"
      ]
    )

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

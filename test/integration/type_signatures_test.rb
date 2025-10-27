# frozen_string_literal: true

require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  def setup
    @object = ruby_objects(:string)
  end

  test "show type signatures" do
    cookies[:signatures] = "enabled"
    get object_url object: @object.path

    assert_response :success
    assert_dom "button", "Disable Type Signatures"
    assert_dom "h4", "(::string other) -> ::Integer"
    assert_dom "h4", "(untyped other) -> ::Integer?"
  end
end

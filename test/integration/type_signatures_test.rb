# frozen_string_literal: true

require "test_helper"

class SearchFlowTest < ActionDispatch::IntegrationTest
  def setup
    @string = ruby_object(:string)
  end

  test "turn on type signatures" do
    get object_url object: @string.path

    assert_select "h4", "to_s → self or string"

    post toggle_signatures_url, headers: { "HTTP_REFERER" => object_url(object: @string.path) }

    follow_redirect!

    assert_select "h4", "(?::int base) -> ::Integer"
  end
end

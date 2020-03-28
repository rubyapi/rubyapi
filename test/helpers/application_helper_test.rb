# frozen_string_literal: true

class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    method = ruby_object(String).ruby_methods.first
    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/v2_6_4/string.c#L76"
  end
end

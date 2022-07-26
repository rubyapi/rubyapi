# frozen_string_literal: true

class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    method = FactoryBot.build(:ruby_method, source_location: "2.6.4:string.c:3")
    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/v2_6_4/string.c#L3"
  end
end

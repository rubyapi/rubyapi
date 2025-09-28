# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    method = FactoryBot.build(:ruby_method, source_location: "3.1.0:string.c:3")

    Current.ruby_release = ruby_releases(:latest)

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/v3_4_2/string.c#L3"
  end

  test "github_url for ruby dev" do
    method = FactoryBot.build(:ruby_method, source_location: "dev:string.c:3")

    Current.ruby_release = ruby_releases(:dev)

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/master/string.c#L3"
  end
end

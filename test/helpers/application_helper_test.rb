# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    Current.ruby_version = ruby_version(:latest)

    method = ruby_method(:instance_method)
    method.source_location = "3.1.0:string.c:3"

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/#{Current.ruby_version.git_tag}/string.c#L3"
  end

  test "github_url for ruby dev" do
    Current.ruby_version = ruby_version(:dev)

    method = ruby_method(:instance_method)
    method.source_location = "dev:string.c:3"

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/#{Current.ruby_version.git_branch}/string.c#L3"
  end
end

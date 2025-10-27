# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  setup do
    @object = ruby_objects(:string)
    @method = ruby_methods(:to_i)
  end

  test "github_url" do
    assert_equal github_url(@method, release: ruby_releases(:latest)), "https://github.com/ruby/ruby/blob/v3_4_2/string.c#L123"
  end

  test "github_url for ruby dev" do
    @object.update(documentable: ruby_releases(:dev))
    assert_equal github_url(@method, release: ruby_releases(:dev)), "https://github.com/ruby/ruby/blob/master/string.c#L123"
  end
end

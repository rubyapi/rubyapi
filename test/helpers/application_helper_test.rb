# frozen_string_literal: true

class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    ruby_version = FactoryBot.build(:ruby_version)
    method = FactoryBot.build(:ruby_method, source_location: "3.1.0:string.c:3")

    Current.ruby_version = ruby_version

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/v3_1_0/string.c#L3"
  end

  test "github_url for ruby dev" do
    ruby_version = FactoryBot.build(:ruby_version, :dev)
    method = FactoryBot.build(:ruby_method, source_location: "dev:string.c:3")

    Current.ruby_version = ruby_version

    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/master/string.c#L3"
  end
end

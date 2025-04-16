require "test_helper"

class RubyGemTest < ActiveSupport::TestCase
  test "validates name and latest version is required" do
    rubygem = RubyGem.new
    assert_not rubygem.valid?
    assert_includes rubygem.errors[:name], "can't be blank"
    assert_includes rubygem.errors[:latest_version], "can't be blank"
  end

  test "getting the latest version" do
    rubygem = ruby_gem(:rails)
    version = ruby_gem_version(:rails)
    assert_equal version, rubygem.latest
  end
end
require "test_helper"

class RubyGemVersionTest < ActiveSupport::TestCase
  test "validates presence of version" do
    version = RubyGemVersion.new(version: nil)
    assert_not version.valid?
    assert_includes version.errors[:version], "can't be blank"
  end
end

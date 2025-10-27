require "test_helper"

class RubyAttributeTest < ActiveSupport::TestCase
  test "validates requried fields" do
    attribute = RubyAttribute.new

    refute attribute.valid?
    assert_includes attribute.errors[:name], "can't be blank"
  end
end

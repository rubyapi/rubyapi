require "test_helper"

class RubyAttributeTest < ActiveSupport::TestCase
  test "raises error on missing name" do
    attribute = RubyAttribute.new(description: "<p>Hello World!</p>")
    assert_not attribute.valid?
    assert_includes attribute.errors[:name], "can't be blank"
  end

  test "default access is public" do
    attribute = RubyAttribute.new(name: "hello_world", description: "<p>Hello World!</p>")
    assert_equal attribute.access, "public"
  end
end

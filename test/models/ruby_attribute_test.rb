require "test_helper"

class RubyAttributeTest < ActiveSupport::TestCase
  test "raises error on missing name" do
    assert_raises(Dry::Struct::Error, "[RubyAttribute.new] :name is missing in Hash input") { RubyAttribute.new }
  end

  test "raises error on missing description" do
    assert_raises(Dry::Struct::Error, "[RubyAttribute.new] :description is missing in Hash input") { RubyAttribute.new(name: "test") }
  end

  test "default access is public" do
    attribute = RubyAttribute.new(name: "hello_world", description: "<p>Hello World!</p>")
    assert_equal attribute.access, "public"
  end
end

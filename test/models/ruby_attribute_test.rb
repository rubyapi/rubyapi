require "test_helper"

class RubyAttributeTest < ActiveSupport::TestCase
  def setup
    @attribute = RubyAttribute.new(name: "HELLO_WORLD", description: "<p>Hello World!</p>", access: "R")
  end

  test "required attributes" do
    assert_equal @attribute.name, "HELLO_WORLD"
    assert_equal @attribute.description, "<p>Hello World!</p>"
    assert_equal @attribute.access, "R"
  end

  test "read?" do
    assert_equal RubyAttribute.new(access: "write").read?, false
    assert_equal RubyAttribute.new(access: "read").read?, true
    assert_equal RubyAttribute.new(access: "read/write").read?, true
  end

  test "readwrite?" do
    assert_equal RubyAttribute.new(access: "write").write?, true
    assert_equal RubyAttribute.new(access: "read").write?, false
    assert_equal RubyAttribute.new(access: "read/write").write?, true
  end

  test "write?" do
    assert_equal RubyAttribute.new(access: "write").readwrite?, false
    assert_equal RubyAttribute.new(access: "read").readwrite?, false
    assert_equal RubyAttribute.new(access: "read/write").readwrite?, true
  end
end

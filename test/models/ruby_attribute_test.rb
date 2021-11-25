require "test_helper"

class RubyAttributeTest < ActiveSupport::TestCase
  def setup
    @attribute = RubyAttribute.new(name: "HELLO_WORLD", description: "<p>Hello World!</p>", access: "Read")
  end

  test "required attributes" do
    assert_equal @attribute.name, "HELLO_WORLD"
    assert_equal @attribute.description, "<p>Hello World!</p>"
    assert_equal @attribute.access, "Read"
  end
end

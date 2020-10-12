require "test_helper"

class RubyConstantTest < ActiveSupport::TestCase
  def setup
    @constant = RubyConstant.new(name: "HELLO_WORLD", description: "<p>Hello World!</p>")
  end

  test "required attributes" do
    assert_equal @constant.name, "HELLO_WORLD"
    assert_equal @constant.description, "<p>Hello World!</p>"
  end
end

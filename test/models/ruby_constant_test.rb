require "test_helper"

class RubyConstantTest < ActiveSupport::TestCase
  test "required fields" do
    constant = RubyConstant.new
    assert_not constant.valid?
    assert_includes constant.errors[:name], "can't be blank"
    assert_includes constant.errors[:constant], "can't be blank"
  end
end

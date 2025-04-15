require "test_helper"

class RubyConstantTest < ActiveSupport::TestCase
  test "validates the presence of name fields" do
    constant = RubyConstant.new(name: nil, description: nil)
    assert_not constant.valid?
    assert_includes constant.errors[:name], "can't be blank"
  end
end

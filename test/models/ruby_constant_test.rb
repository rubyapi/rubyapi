require "test_helper"

class RubyConstantTest < ActiveSupport::TestCase
  test "raises error on missing name" do
    assert_raises(Dry::Struct::Error, "[RubyAttribute.new] :name is missing in Hash input") { RubyAttribute.new }
  end

  test "raises error on missing description" do
    assert_raises(Dry::Struct::Error, "[RubyAttribute.new] :description is missing in Hash input") { RubyAttribute.new(name: "test") }
  end
end

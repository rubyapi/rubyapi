require 'test_helper'

class RubyMethodTest < ActiveSupport::TestCase
  test "required attribues" do
    ruby_method = RubyMethod.create

    assert_includes ruby_method.errors[:name], "can't be blank"
    assert_includes ruby_method.errors[:method_type], "can't be blank"
    assert_includes ruby_method.errors[:version], "can't be blank"
  end
end

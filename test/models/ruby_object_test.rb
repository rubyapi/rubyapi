require "test_helper"

class RubyObjectTest < ActiveSupport::TestCase
  test "requried attributes" do
    ruby_object = RubyObject.create

    assert_includes ruby_object.errors[:name], "can't be blank"
    assert_includes ruby_object.errors[:constant], "can't be blank"
    assert_includes ruby_object.errors[:object_type], "can't be blank"
    assert_includes ruby_object.errors[:version], "can't be blank"
  end

  test "#generate_path" do
    string = ruby_objects(:string)
    string.save

    assert_equal string.path, "string"

    mjit = ruby_objects(:mjit)
    mjit.save

    assert_equal mjit.path, "rubyvm/mjit"
  end
end

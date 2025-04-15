# frozen_string_literal: true

require "test_helper"

class RubyObjectTest < ActiveSupport::TestCase
  setup do
    @object = ruby_object(:string)
    @module = ruby_object(:comparable)
  end

  test "validates presence of name and path" do
    object = RubyObject.new
    assert_not object.valid?
    assert_includes object.errors[:name], "can't be blank"
    assert_includes object.errors[:path], "can't be blank"
  end

  test "validates object_type inclusion" do
    object = RubyObject.new(object_type: "invalid_type")
    assert_not object.valid?
    assert_includes object.errors[:object_type], "is not included in the list"
  end

  test "object types" do
    assert @object.class_object?
    assert_not @object.module_object?

    assert @module.module_object?
    assert_not @module.class_object?
  end
end

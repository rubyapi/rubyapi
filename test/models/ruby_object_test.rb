require "test_helper"

class RubyObjectTest < ActiveSupport::TestCase
  test "object types" do
    class_object = RubyObject.new(object_type: "class")
    module_object = RubyObject.new(object_type: "module")

    assert class_object.class_object?
    refute class_object.module_object?

    assert module_object.module_object?
    refute module_object.class_object?
  end

  test "included modules" do
    object = ruby_objects(:string)
    included_module = ruby_objects(:enumerable)

    object.update(included_module_constants: ["Enumerable"])

    assert_includes object.included_modules, included_module
  end
end

# frozen_string_literal: true

require "test_helper"

class RubyObjectTest < ActiveSupport::TestCase
  def setup
    @object = FactoryBot.build(:ruby_object, c: "String")
  end

  test "equality" do
    other_object = FactoryBot.build(:ruby_object, c: Integer)
    assert_not @object == other_object
  end

  test "generate id from path" do
    # base64 encoding of given path
    assert_equal "Zm9vL2Jhcg==", RubyObject.id_from_path("foo/bar")
  end

  test "object types" do
    assert @object.class_object?
    refute @object.module_object?
  end

  test "filter ruby methods" do
    class_methods = FactoryBot.build_list(:ruby_method, 3, method_type: "class_method")
    instance_methods = FactoryBot.build_list(:ruby_method, 2, method_type: "instance_method")

    ruby_object = FactoryBot.build(:ruby_object, ruby_methods: class_methods + instance_methods)

    assert_equal 3, ruby_object.ruby_class_methods.size
    assert_equal 2, ruby_object.ruby_instance_methods.size
  end
end

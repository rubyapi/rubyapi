# frozen_string_literal: true

require "test_helper"

class RubyObjectTest < ActiveSupport::TestCase
  def setup
    @constant = "String"

    attributes = {
      name: "String",
      description: "<h1>Hello World</h1>",
      object_type: "class_object",
      constant: @constant,
      superclass: "Object",
      included_modules: ["Kernel"],
      metadata: {
        depth: 1
      },
      methods: [
        {
          name: "to_i",
          description: "<h1>Hello World</h1>",
          method_type: "instance_method",
          object_constant: "String",
          source_location: "2.6.4:string.c:L54",
          metadata: {
            depth: 1
          },
          call_sequence: <<~G,
            str.to_i # => 1
          G
          alias: {
            path: "String.html#to_integer",
            name: "to_integer"
          }
        }
      ]
    }

    @object = RubyObject.new attributes
  end

  test "requried attributes" do
    assert_equal @object.name, "String"
    assert_equal @object.object_type, "class_object"
    assert_equal @object.constant, "String"
    assert_equal @object.superclass, RubyObject.new(constant: "Object")
    assert_equal @object.included_modules, [RubyObject.new(constant: "Kernel")]
    assert_equal @object.description, "<h1>Hello World</h1>"
  end

  test "#==" do
    assert_equal @object, RubyObject.new(constant: @constant)
  end

  test "#id" do
    assert_equal @object.id, "c3RyaW5n"
  end

  test "#class_method?" do
    object = RubyObject.new(object_type: "class_object")
    assert_equal object.class_object?, true
  end

  test "#module_object?" do
    object = RubyObject.new(object_type: "module_object")
    assert_equal object.module_object?, true
  end

  test "ruby_methods" do
    method = @object.ruby_methods.first
    assert_equal method.class, RubyMethod
  end

  test "#to_hash" do
    object_hash = @object.to_hash
    assert_equal object_hash.sort.to_h, {
      autocomplete: "String",
      constant: "String",
      description: "<h1>Hello World</h1>",
      id: "c3RyaW5n",
      included_modules: ["Kernel"],
      metadata: {
        depth: 1
      },
      methods: [{
        name: "to_i",
        description: "<h1>Hello World</h1>",
        type: :method,
        autocomplete: "String#to_i",
        object_constant: "String",
        identifier: "String#to_i",
        method_type: "instance_method",
        source_location: "2.6.4:string.c:L54",
        call_sequence: <<~G,
          str.to_i # => 1
        G
        alias: {
          path: "String.html#to_integer",
          name: "to_integer"
        },
        metadata: {
          depth: 1
        }
      }],
      name: "String",
      object_type: "class_object",
      superclass: "Object",
      type: :object
    }
  end
end

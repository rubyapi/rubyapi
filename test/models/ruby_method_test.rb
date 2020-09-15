# frozen_string_literal: true

require "test_helper"

class RubyMethodTest < ActiveSupport::TestCase
  def setup
    attributes = {
      name: "to_i",
      description: "<h1>Hello World</h1>",
      method_type: "instance_method",
      object_constant: "String",
      source_location: "2.6.4:string.c:L54",
      metadata: {
        depth: 1
      },
      alias: {
        path: "String.html#to_integer",
        name: "to_integer"
      },
      call_sequence: <<~G,
        str.to_i # => 1
      G
      source_body: <<~SRC
        puts "Hello world!"
      SRC
    }

    @method = RubyMethod.new(attributes)
    @class_method = RubyMethod.new(method_type: "class_method")
  end

  test "required attribues" do
    assert_equal @method.name, "to_i"
    assert_equal @method.description, "<h1>Hello World</h1>"
    assert_equal @method.method_type, "instance_method"
    assert_equal @method.object_constant, "String"
    assert_equal @method.source_location, "2.6.4:string.c:L54"
    assert_equal @method.call_sequence, <<~G
      str.to_i # => 1
    G
    assert_equal @method.source_body, <<~SRC
      puts "Hello world!"
    SRC
  end

  test "#instance_method?" do
    assert_equal @method.instance_method?, true
    assert_equal @class_method.instance_method?, false
  end

  test "#class_method?" do
    assert_equal @class_method.class_method?, true
    assert_equal @method.class_method?, false
  end

  test "#identifier" do
    assert_equal @method.identifier, "String#to_i"
  end

  test "#method_is_alias?" do
    method = RubyMethod.new(name: "size", alias: {path: "Array#length", name: "length"})
    assert method.alias?
  end

  test "#alias_name" do
    method = RubyMethod.new(name: "size", alias: {path: "Array.html#length", name: "length"})
    assert_equal method.alias_name, "length"
  end

  test "#alias_path" do
    method = RubyMethod.new(name: "size", alias: {path: "Array.html#length", name: "length"})
    assert_equal method.alias_path, "Array.html#length"
  end

  test "#to_hash" do
    method_hash = @method.to_hash
    assert_equal method_hash.sort.to_h, {
      alias: {
        name: "to_integer",
        path: "String.html#to_integer"
      },
      autocomplete: "String#to_i",
      call_sequence: <<~G,
        str.to_i # => 1
      G
      description: "<h1>Hello World</h1>",
      identifier: "String#to_i",
      metadata: {
        depth: 1
      },
      method_type: "instance_method",
      name: "to_i",
      object_constant: "String",
      source_body: <<~SRC,
        puts "Hello world!"
      SRC
      source_location: "2.6.4:string.c:L54",
      type: :method
    }
  end
end

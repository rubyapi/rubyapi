require "test_helper"

class RubyMethodTest < ActiveSupport::TestCase
  def setup
    attributes = {
      name: "to_i",
      description: "<h1>Hello World</h1>",
      method_type: "instance_method",
      object_constant: "String",
      source_location: "2.6.4:string.c:L54",
      call_sequence: <<~G
        str.to_i # => 1
      G
    }

    @method = RubyMethod.new(attributes)
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
  end

  test "#instance_method?" do
    assert_equal @method.instance_method?, true
  end

  test "#class_method?" do
    method = RubyMethod.new(method_type: "class_method")
    assert_equal method.class_method?, true
  end

  test "#identifier" do
    assert_equal @method.identifier, "String#to_i"
  end

  test "#to_hash" do
    assert_equal @method.to_hash, {
      name: "to_i",
      description: "<h1>Hello World</h1>",
      type: :method,
      autocomplete: "String#to_i",
      object_constant: "String",
      identifier: "String#to_i",
      method_type: "instance_method",
      source_location: "2.6.4:string.c:L54",
      call_sequence: <<~G
        str.to_i # => 1
      G
    }
  end
end

require "test_helper"

class RubyMethodTest < ActiveSupport::TestCase
  test "method type validation" do
    method = RubyMethod.new(method_type: "invalid_type")
    refute method.valid?
    assert_includes method.errors[:method_type], "is not included in the list"
  end

  test "instance method" do
    method = RubyMethod.new(method_type: "instance")

    assert method.instance_method?
    refute method.class_method?
  end

  test "class method" do
    method = RubyMethod.new(method_type: "class")

    assert method.class_method?
    refute method.instance_method?
  end

  test "type identifier" do
    instance_method = RubyMethod.new(method_type: "instance")
    class_method = RubyMethod.new(method_type: "class")

    assert_equal "#", instance_method.type_identifier
    assert_equal ".", class_method.type_identifier
  end

  test "aliased method" do
    aliased_method = RubyMethod.new(method_alias: "alias_name")
    non_aliased_method = RubyMethod.new(method_alias: nil)

    assert aliased_method.is_alias?
    refute non_aliased_method.is_alias?
  end

  test "source file and line" do
    method = RubyMethod.new(source_location: "path/to/file.rb:42")

    assert_equal "path/to/file.rb", method.source_file
    assert_equal 42, method.source_line
  end
end

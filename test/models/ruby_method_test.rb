# frozen_string_literal: true

require "test_helper"

class RubyMethodTest < ActiveSupport::TestCase
  def setup
    @method = FactoryBot.build(:ruby_method, object_constant: "String", name: "to_s")
    @class_method = FactoryBot.build(:ruby_method, :class_method, object_constant: "String", name: "new")
  end

  test "raises error on missing name" do
    assert_raises(Dry::Struct::Error, "[RubyMethod.new] :name is missing in Hash input") { RubyMethod.new }
  end

  test "method types" do
    assert @method.instance_method?
    assert_not @class_method.instance_method?

    assert @class_method.class_method?
    assert_not @method.class_method?
  end

  test "method identifier" do
    assert_equal @method.identifier, "String#to_s"
    assert_equal @class_method.identifier, "String::new"
  end

  test "method alias" do
    @aliased_method = FactoryBot.build(:ruby_method, :alias, method_alias: {name: "to_integer", path: "String.html#to_integer"})

    assert @aliased_method.is_alias?
    assert_not @method.is_alias?

    assert_equal @aliased_method.method_alias.name, "to_integer"
    assert_equal @aliased_method.method_alias.path, "String.html#to_integer"
  end

  test "default signature" do
    method = RubyMethod.new(
      name: "to_s",
      object_constant: "String",
      description: "Returns the string representation of obj.",
      method_type: "instance_method",
      source_location: "string.rb:1",
      call_sequence: ["String#to_s"],
      source_body: "def to_s",
      metadata: {},
      method_alias: {
        name: nil,
        path: nil
      }
    )

    assert_equal method.signatures, []
  end
end

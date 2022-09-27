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

  test "to search" do
    assert_equal @method.to_search, {type: :method, autocomplete: "String#to_s", name: "to_s", method_type: "instance_method", description: "<p>Returns the result of interpreting leading characters in self as an integer in the given base (which must be in (2..36)):</p>"}
  end
end

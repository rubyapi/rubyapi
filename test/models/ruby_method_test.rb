# frozen_string_literal: true

require "test_helper"

class RubyMethodTest < ActiveSupport::TestCase
  def setup
    @method = ruby_method(:instance_method)
    @class_method = ruby_method(:class_method)
  end

  test "raises error on missing name" do
    method = RubyMethod.new

    assert_not method.valid?
    assert_includes method.errors[:name], "can't be blank"
  end

  test "method types" do
    assert @method.instance_method?
    assert_not @class_method.instance_method?

    assert @class_method.class_method?
    assert_not @method.class_method?
  end

  test "method constant" do
    assert_equal @method.constant, "String#to_s"
    assert_equal @class_method.constant, "String.new"
  end

  test "method alias" do
    @aliased_method = ruby_method(:aliased_method)

    assert @aliased_method.is_alias?
    assert_not @method.is_alias?
  end
end

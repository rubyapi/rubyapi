# frozen_string_literal: true

class RubyObject < Dry::Struct
  include Identifiable

  attribute :name, Types::String
  attribute :description, Types::String
  attribute :object_type, Types::String
  attribute :constant, Types::String
  attribute :superclass, RubyObjectSuperclass.optional.default(nil)

  attribute :ruby_methods, Types::Strict::Array.of(RubyMethod)
  attribute :ruby_attributes, Types::Strict::Array.of(RubyAttribute)
  attribute :ruby_constants, Types::Strict::Array.of(RubyConstant)
  attribute :included_modules, Types::Strict::Array.of(RubyObjectIncludedModule)

  attribute :metadata, Dry::Struct.meta(omittable: true) do
    attribute :depth, Types::Integer
  end

  alias_method :autocomplete, :constant

  def class_object?
    object_type == "class_object"
  end

  def module_object?
    object_type == "module_object"
  end

  def ==(other)
    constant == other.constant
  end

  def ruby_class_methods
    @ruby_class_methods ||=
      ruby_methods.select(&:class_method?).sort_by(&:name)
  end

  def ruby_instance_methods
    @ruby_instance_methods ||=
      ruby_methods.select(&:instance_method?).sort_by(&:name)
  end

  def to_search
    to_h.merge(type: :object, autocomplete:)
  end
end

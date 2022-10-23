# frozen_string_literal: true

class RubyMethod < Dry::Struct
  attribute :name, Types::String
  attribute :description, Types::String
  attribute :object_constant, Types::String
  attribute :method_type, Types::String
  attribute :source_location, Types::String
  attribute :call_sequence, Types::Array
  attribute :source_body, Types::String
  attribute :signatures, Types::Array.default([].freeze)

  attribute :metadata do
    attribute :depth, Types::Coercible::Integer.default(1)
  end

  attribute :method_alias do
    attribute :name, Types::String.optional
    attribute :path, Types::String.optional
  end

  def class_method?
    method_type == "class_method"
  end

  def instance_method?
    method_type == "instance_method"
  end

  def type_identifier
    if class_method? then "::"
    elsif instance_method? then "#"
    else
      raise "Unknown type of method: #{method_type}"
    end
  end

  def identifier
    [object_constant, type_identifier, name].join
  end

  alias_method :autocomplete, :identifier

  def object_path
    object_constant&.downcase&.gsub(/::/, "/")
  end

  def is_alias?
    method_alias.attributes.values.any?
  end

  def source_file
    source_properties[1]
  end

  def source_line
    source_properties[2]
  end

  # Similar to #to_h, but only the nessessary attributes are included
  def to_search
    to_h.merge(type: :method, autocomplete:)
  end

  private

  def source_properties
    source_location.split(":")
  end
end

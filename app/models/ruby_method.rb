# frozen_string_literal: true

class RubyMethod
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def name
    body[:name]
  end

  def description
    body[:description]
  end

  def method_type
    body[:method_type]
  end

  def object_constant
    body[:object_constant]
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

  def source_location
    body[:source_location]
  end

  def call_sequence
    body[:call_sequence]
  end

  def autocomplete
    identifier
  end

  def object_path
    object_constant&.downcase&.gsub(/::/, "/")
  end

  def metadata
    body[:metadata]
  end

  def alias?
    method_alias.values.any?
  end

  def alias_path
    method_alias[:path]
  end

  def alias_name
    method_alias[:name]
  end

  def method_alias
    body[:alias] || {}
  end

  def source_body
    body[:source_body]
  end

  def source_file
    source_properties[1]
  end

  def source_line
    source_properties[2]
  end

  def to_hash
    {
      name: name,
      description: description,
      type: :method,
      autocomplete: autocomplete,
      object_constant: object_constant,
      identifier: identifier,
      method_type: method_type,
      source_location: source_location,
      call_sequence: call_sequence,
      alias: method_alias,
      source_body: source_body,
      metadata: metadata
    }
  end

  private

  def source_properties
    source_location.split(":")
  end
end

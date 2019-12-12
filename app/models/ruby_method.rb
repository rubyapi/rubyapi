# frozen_string_literal: true

class RubyMethod
  attr_reader :body

  def initialize(body)
    @body = HashWithIndifferentAccess.new(body)
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

  def instance_method?
    method_type == "instance_method"
  end

  def class_method?
    method_type == "class_method"
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
    object_constant&.downcase&.gsub(/\:\:/, "/")
  end

  def metadata
    body[:metadata]
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
      metadata: metadata,
    }
  end

  private

  def type_identifier
    if instance_method?
      "#"
    elsif class_method?
      "::"
    end
  end
end

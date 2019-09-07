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

  def metadata
    body[:metadata]
  end

  def method_type
    metadata[:method_type]
  end

  def parent_constant
    metadata[:parent_constant]
  end

  def instance_method?
    method_type == "instance_method"
  end

  def class_method?
    method_type == "class_method"
  end

  def identifier
    [parent_constant, type_identifier, name].join
  end

  def source_location
    metadata[:source_location]
  end

  def call_sequence
    metadata[:call_sequence]
  end

  def to_elasticsearch
    {
      name: name,
      description: description,
      type: :method,
      metadata: {
        identifier: identifier,
        method_type: method_type,
        source_location: source_location,
        call_sequence: call_sequence
      }
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

  def parent_name
    ruby_object.name
  end
end

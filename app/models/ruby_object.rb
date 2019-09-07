# frozen_string_literal: true

class RubyObject
  attr_reader :body

  def initialize(body)
    @body = HashWithIndifferentAccess.new(body)
  end

  def id
    Base64.encode64(path)
  end

  def name
    body[:name]
  end

  def metadata
    body[:metadata]
  end

  def path
    constant&.downcase&.gsub(/\:\:/, "/")
  end

  def object_type
    metadata[:object_type]
  end

  def class_object?
    object_type == "class_object"
  end

  def module_object?
    object_type == "module_object"
  end

  def constant
    metadata[:constant]
  end

  def description
    body[:description]
  end

  # This is be empty in search pages
  def ruby_methods
    @ruby_methods ||= metadata[:methods].collect { |m| RubyMethod.new(m) }
  end

  def to_elasticsearch
    {
      id: id,
      name: name,
      type: :object,
      description: description,
      metadata: {
        constant: constant,
        object_type: object_type,
        methods: ruby_methods.collect(&:to_elasticsearch),
      }
    }
  end
end

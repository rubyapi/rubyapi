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

  def path
    constant&.downcase&.gsub(/\:\:/, "/")
  end

  def object_type
    body[:object_type]
  end

  def class_object?
    object_type == "class_object"
  end

  def module_object?
    object_type == "module_object"
  end

  def constant
    body[:object_constant]
  end

  def description
    body[:description]
  end

  def autocomplete
    constant
  end

  # This is be empty in search pages
  def ruby_methods
    @ruby_methods ||= body[:object_methods].collect { |m| RubyMethod.new(m) }
  end

  def to_elasticsearch
    {
      id: id,
      name: name,
      type: :object,
      description: description,
      autocomplete: autocomplete,
      object_methods: ruby_methods.collect(&:to_elasticsearch),
      object_constant: constant,
      object_object_type: object_type,
    }
  end
end

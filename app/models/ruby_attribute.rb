# frozen_string_literal: true

class RubyAttribute
  attr_reader :body

  def initialize(body = {})
    @body = body
  end

  def name
    body[:name]
  end

  def description
    body[:description]
  end

  def access
    body[:access]
  end

  def to_hash
    {
      name: name,
      description: description,
      access: access
    }
  end
end

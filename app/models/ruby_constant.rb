class RubyConstant

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

  def to_hash
    {
      name: name,
      description: description,
    }
  end
end
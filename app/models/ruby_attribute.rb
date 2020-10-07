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

  def read?
    access == "read" || readwrite?
  end

  def write?
    access == "write" || readwrite?
  end

  def readwrite?
    access == "readwrite"
  end

  def to_hash
    {
      name: name,
      description: description,
      access: access
    }
  end
end

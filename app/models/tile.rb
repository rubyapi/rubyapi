class Tile
  attr_reader :name, :classes

  def initialize(name, classes)
    @name = name
    @classes = classes
  end
end

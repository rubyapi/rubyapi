class Tile
  attr_reader :name, :description, :classes

  def initialize(name, description, classes)
    @name = name
    @description = description
    @classes = classes
  end
end

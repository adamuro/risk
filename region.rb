require_relative 'common'

class Region
  Position = Struct.new(:x, :y)
  def initialize(name, position)
    @name = name
    @image = Gosu::Image.new(img_name(name))
    @position = position
    @soldiers = 0
    @color = Gosu::Color::RED
  end

  def draw
    @image.draw(@position.x, @position.y, 1, 1, 1, @color)
  end
end

class Alaska < Region
  def initialize
    super('Alaska', Position.new(-22, 36))
  end
end
class Region
  Position = Struct.new(:x, :y)

  attr_accessor :color, :name

  def initialize(name, x, y)
    @name = name
    @position = Position.new(x, y)
    @image = Gosu::Image.new(img_name(name))
    @neighbors = []
    @soldiers = 0
    @color = Gosu::Color::RED
  end

  def neighbor?(region)
    @neighbors.include?(region)
  end

  def add_neighbor(*regions)
    @neighbors |= regions
  end

  def draw
    @image.draw(@position.x, @position.y, 1, 1, 1, @color)
  end

  def img_name(name)
    'images/map/' + name.downcase.gsub(' ', '_') + '.png'
  end
end


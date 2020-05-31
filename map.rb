require_relative 'continent'

class Map
  def initialize
    @image = Gosu::Image.new('images/map.png')
    @continents = [NorthAmerica.new,
                   SouthAmerica.new]
  end
  def draw
    @image.draw(0, 0, 0)
    @continents.each(&:draw)
  end
end
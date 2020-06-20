class Color
  def initialize(r, g, b, a)
    @red = r
    @green = g
    @blue = b
    @alpha = a
  end

  def get
    Gosu::Color.rgba(@red, @green, @blue, @alpha)
  end

  def lighten
    red = [255, @red + 140].min
    green = [255, @green + 140].min
    blue = [255, @blue + 140].min
    Gosu::Color.rgba(red, green, blue, @alpha)
  end

  RED = Color.new(255, 0, 0, 255)
  GREEN = Color.new(0, 255, 0, 255)
  BLUE = Color.new(0, 0, 255, 255)
  YELLOW = Color.new(255, 255, 0, 255)
end
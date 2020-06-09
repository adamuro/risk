class Region
  Position = Struct.new(:x, :y)

  attr_accessor :color, :name

  def initialize(name, x, y, font_shift_x = 0, font_shift_y = 0)
    @name = name
    @image = Gosu::Image.new(img_name(name))
    @color = Gosu::Color::RED
    @position = Position.new(x, y)
    @font_pos = Position.new(@position.x + @image.width / 2 + font_shift_x,
                             @position.y + @image.height / 2 + font_shift_y)
    @font = Gosu::Font.new(20, name: 'fonts/GROBOLD.ttf')
    @neighbors = []
    @troops = 0
  end

  def neighbor?(region)
    @neighbors.include?(region)
  end

  def add_neighbor(*regions)
    @neighbors |= regions
  end

  def add_troops(troops = 1)
    @troops += troops
  end

  def clicked?(mouse_x, mouse_y)
    Gosu.distance(mouse_x, mouse_y, @font_pos.x, @font_pos.y) < 15
  end

  def draw
    @image.draw(@position.x, @position.y, 1, 1, 1, @color)
    @font.draw_text_rel(@troops.to_s, @font_pos.x, @font_pos.y, 2, 0.5, 0.5)
  end

  def img_name(name)
    'images/map/' + name.downcase.gsub(' ', '_') + '.png'
  end
end


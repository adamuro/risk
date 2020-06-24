class Text
  attr_accessor :text
  Vector = Struct.new(:x, :y)
  def initialize(x, y, size)
    @font = Gosu::Font.new(size, name: 'fonts/BebasNeue-Regular.ttf')
    @position = Vector.new(x, y)
    @text = ''
  end

  def draw(text = @text)
    @font.draw_text_rel(text, @position.x, @position.y, ZOrder::TEXT, 0.5, 0)
  end
end
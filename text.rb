class Text
  attr_accessor :text
  Vector = Struct.new(:x, :y)
  def initialize(x, y, size, *options)
    @font = Gosu::Font.new(size, name: 'fonts/BebasNeue-Regular.ttf')
    @position = Vector.new(x, y)
    @options = options
    @text = ''
  end

  def draw(text = @text)
    if @options.include?(:center)
      @font.draw_text_rel(text, @position.x, @position.y, 1, 0.5, 0)
    else
      @font.draw_text(text, @position.x, @position.y, 1)
    end
  end
end
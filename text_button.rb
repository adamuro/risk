class TextButton
  Vector = Struct.new(:x, :y)

  def initialize(text, x, y, width, height, *options)
    @text = text
    @position = Vector.new(x, y)
    @size = Vector.new(width, height)
    @font = Gosu::Font.new(height, name: 'fonts/BebasNeue-Regular.ttf')
    @options = options
  end

  def draw
    if @options.include?(:center)
      @font.draw_text_rel(@text, @position.x, @position.y, 1, 0.5, 0)
    else
      @font.draw_text(@text, @position.x, @position.y, 1)
    end
  end

  def clicked?(m_x, m_y)
    x_center = m_x > @position.x - @size.x / 2 && m_x < @position.x + @size.x / 2
    x_normal = m_x > @position.x && m_x < @position.x + @size.x
    x_clicked = @options.include?(:center) ? x_center : x_normal
    y_clicked = m_y > @position.y && m_y < @position.y + @size.y
    x_clicked && y_clicked
  end
end
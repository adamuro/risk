require_relative 'common'
require_relative 'color'

Vector = Struct.new(:x, :y)

class TextButton
  def initialize(text, x, y, width, height)
    @text = text
    @position = Vector.new(x, y)
    @size = Vector.new(width, height - 10)
    @font = Gosu::Font.new(height, name: 'fonts/BebasNeue-Regular.ttf')
  end

  def draw(m_x, m_y)
    @font.draw_text_rel(@text, @position.x, @position.y, ZOrder::TEXT, 0.5, 0)
    if clicked?(m_x, m_y)
      Gosu::draw_rect(@position.x - @size.x / 2, @position.y + 2, @size.x, @size.y, Color::GREY.get, ZOrder::TEXT_COVER)
    end
  end

  def clicked?(m_x, m_y)
    x_clicked = m_x > @position.x - @size.x / 2 && m_x < @position.x + @size.x / 2
    y_clicked = m_y > @position.y && m_y < @position.y + @size.y
    x_clicked && y_clicked
  end
end

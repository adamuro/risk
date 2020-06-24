require_relative 'text_button'

class TransportManager
  attr_reader :troops, :max, :confirm

  def initialize
    @troops = 1
    @font = Gosu::Font.new(50, name: 'fonts/BebasNeue-Regular.ttf')
    @confirm = TextButton.new('Confirm', Window::CENTER_X, 660, 140, 55)
    @plus = TextButton.new('+', Window::CENTER_X + 40, 620, 40, 50)
    @minus = TextButton.new('-', Window::CENTER_X - 40, 620, 40, 50)
  end

  def turn_on(max)
    @troops = 1
    @max = max
  end

  def draw(m_x, m_y)
    @font.draw_text_rel(@troops.to_s, 640, 620, ZOrder::TEXT, 0.5, 0)
    @confirm.draw(m_x, m_y)
    @plus.draw(m_x, m_y)
    @minus.draw(m_x, m_y)
  end

  def add
    @troops += 1
    @troops = 1 if @troops == @max
  end

  def sub
    @troops = @max if @troops == 1
    @troops -= 1
  end

  def event(m_x, m_y)
    add if @plus.clicked?(m_x, m_y)
    sub if @minus.clicked?(m_x, m_y)
  end

  def clicked?(m_x, m_y)
    [@confirm, @plus, @minus].any? { |button| button.clicked?(m_x, m_y)}
  end
end
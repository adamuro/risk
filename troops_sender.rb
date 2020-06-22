require_relative 'text_button'

class TroopsSender
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

  def draw(mouse_x, mouse_y)
    @font.draw_text_rel(@troops.to_s, 640, 620, ZOrder::TEXT, 0.5, 0)
    @confirm.draw(mouse_x, mouse_y)
    @plus.draw(mouse_x, mouse_y)
    @minus.draw(mouse_x, mouse_y)
  end

  def add
    @troops += 1
    @troops = 1 if @troops == @max
  end

  def sub
    @troops = @max if @troops == 1
    @troops -= 1
  end

  def event(mouse_x, mouse_y)
    add if @plus.clicked?(mouse_x, mouse_y)
    sub if @minus.clicked?(mouse_x, mouse_y)
  end

  def clicked?(mouse_x, mouse_y)
    [@confirm, @plus, @minus].any? { |button| button.clicked?(mouse_x, mouse_y)}
  end
end
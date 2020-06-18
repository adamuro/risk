class TroopsSender
  # make plus and minus classes to draw and click them
  attr_reader :troops, :max

  def initialize
    @troops = 1
    @font = Gosu::Font.new(40, name: 'fonts/BebasNeue-Regular.ttf')
  end

  def turn_on(max)
    @troops = 1
    @max = max
  end

  def draw
    @font.draw_text_rel("- #{@troops} +", 640, 640, 3, 0.5, 0.5)
    @font.draw_text_rel('Confirm', 640, 680, 3, 0.5, 0.5)
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
    add if Gosu.distance(655, 640, mouse_x, mouse_y) < 10
    sub if Gosu.distance(625, 640, mouse_x, mouse_y) < 10
  end

  def confirm_clicked?(mouse_x, mouse_y)
    mouse_x > 600 && mouse_x < 680 && mouse_y > 660 && mouse_y < 700
  end
end
require 'gosu'
require_relative 'map'
require_relative 'players'
require_relative 'text_button'
require_relative 'message'
require_relative 'common'

class Risk < Gosu::Window
  def initialize
    super(Window::WIDTH, Window::HEIGHT)
    self.caption = 'Risk'
    @map = Map.new
    @players = Players.new
    @players.distribute_regions(@map)
    @players.distribute_troops
    @players.current.start_turn
    @next_phase_button = TextButton.new('Next phase', 1165, 10, 200, 60)
    @exit_button = TextButton.new('Exit', 50, 10, 80, 60)
  end

  def update
    @players.update(@map)
    return unless @players.count == 1

    Message.win(@players.current)
    close
  end

  def draw
    @map.draw(@players.current.regions.chosen, @players.current.color)
    @next_phase_button.draw(mouse_x, mouse_y)
    @exit_button.draw(mouse_x, mouse_y)
    @players.draw(mouse_x, mouse_y)
  end

  def button_up(button)
    return unless button == Gosu::MS_LEFT

    close if @exit_button.clicked?(mouse_x, mouse_y)
    @players.current.next_phase if @next_phase_button.clicked?(mouse_x, mouse_y)
    @players.current.event(mouse_x, mouse_y)
  end

  def needs_cursor?
    true
  end

  def fullscreen?
    false
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

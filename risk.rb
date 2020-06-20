require 'gosu'
require_relative 'map'
require_relative 'players'
require_relative 'text_button'

class Risk < Gosu::Window
  def initialize
    super(1280, 720)
    self.caption = 'Risk'
    @map = Map.new
    @players = Players.new
    @players.distribute_regions(@map)
    @players.distribute_troops
    @players.current.start_turn
    @next_phase_button = TextButton.new('Next phase', 1060, 10, 190, 60)
  end

  def update
    if !@players.current.troops_avail? && @players.current.phase == Phase::DRAW
      @players.current.next_phase
    elsif @players.current.end_turn?
      @players.next
      @players.current.territory_award(@map)
    end

    close if Gosu.button_down? Gosu::KB_ESCAPE
  end

  def draw
    @map.draw(@players.current.regions.chosen)
    @next_phase_button.draw
    @players.draw
  end

  def button_up(button)
    @players.current.event(mouse_x, mouse_y) if button == Gosu::MS_LEFT
    @players.current.next_phase if @next_phase_button.clicked?(mouse_x, mouse_y)
  end

  def needs_cursor?
    true
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

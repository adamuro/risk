require 'gosu'
require_relative 'map'
require_relative 'players'

class Risk < Gosu::Window
  def initialize
    super(1280, 720)
    self.caption = 'Risk'
    @map = Map.new
    @players = Players.new
    @players.distribute_regions(@map)
    @players.distribute_troops
    @players.current.start_turn
    # add some SKIP button to skip phases
  end

  def update
    if !@players.current.troops_avail? && @players.current.phase == Phase::DRAW
      @players.current.next_phase
    elsif @players.current.end_turn?
      @players.next
      @players.current.territory_award(@map)
      # this should be in other class
    end

    close if Gosu.button_down? Gosu::KB_ESCAPE
  end

  def draw
    @map.draw
    @players.draw
    # draw current player(and their troops if drawing)
  end

  def button_up(button)
    #if next_turn_button.clicked?
    #@players.current.next_phase
    @players.current.event(mouse_x, mouse_y) if button == Gosu::MS_LEFT
    if mouse_x > 1200 && mouse_y > 640
      @players.current.next_phase
    end
  end

  def needs_cursor?
    true
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

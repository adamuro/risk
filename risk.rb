require 'gosu'
require_relative 'map'
require_relative 'players'

class Risk < Gosu::Window
  def initialize
    super(1280, 720)
    self.caption = 'Risk'
    @map = Map.new
    @players = Players.new
    # add some SKIP button to skip phases
    distribute_regions
    distribute_troops
    @players.current.start_turn
  end

  def distribute_regions
    all_regions = @map.all_regions.shuffle
    all_regions.count.times do |i|
      @players.get(i % @players.count).add_region(all_regions[i])
    end
  end

  def distribute_troops(troops = 30)
    @players.to_arr.each do |player|
      player.regions.each(&:add_troops)
      troops.times { player.rand_region.add_troops }
    end
  end

  def update
    if !@players.current.troops_avail? && @players.current.phase == Phase::DRAW
      @players.current.next_phase
    elsif @players.current.end_turn?
      @players.next
      @map.continents.each do |continent|
        if @players.current.occupy?(continent.regions)
          @players.current.add_troops(continent.value)
        end
      end
    end

    close if Gosu.button_down? Gosu::KB_ESCAPE
  end

  def draw
    @map.draw
    # draw current player(and their troops if drawing)
  end

  def button_up(button)
    # check if SKIP was clicked, if so call player's next_turn func
    @players.current.event(mouse_x, mouse_y) if button == Gosu::MS_LEFT
  end

  def needs_cursor?
    true
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

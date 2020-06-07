require 'gosu'
require_relative 'map'
require_relative 'player'

class Risk < Gosu::Window
  def initialize
    super(1280, 720)
    self.caption = 'Risk'
    @map = Map.new
    @players = [@p1 = Player.new(Gosu::Color::RED),
                @p2 = Player.new(Gosu::Color::BLUE),
                @p3 = Player.new(Gosu::Color::YELLOW),
                @p4 = Player.new(Gosu::Color::GREEN)]
    @current_player = @p1
    assign_regions_to_players
  end

  def assign_regions_to_players
    all_regions = @map.all_regions.shuffle
    all_regions.count.times do |i|
      @players[i % @players.count].add_region(all_regions[i])
    end
  end

  def needs_cursor?
    true
  end

  def update
    close if Gosu.button_down? Gosu::KB_ESCAPE
  end

  def draw
    @map.draw
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

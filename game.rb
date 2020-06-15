require 'gosu'
require_relative 'map'

class Game < Gosu::Window
  def initialize(window)
    @window = window
    @map = Map.new
    @map.assign_borders
    @players = [@p1 = Player.new(Gosu::Color::RED),
                @p2 = Player.new(Gosu::Color::BLUE)]
    @current_player = @p1
  end

  def update

  end

  def draw
    @map.draw
  end
end
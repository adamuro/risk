require 'gosu'
require_relative 'map'

class Game < Gosu::Window
  def initialize(window)
    @window = window
    @map = Map.new
  end

  def update

  end

  def draw
    @map.draw
  end
end
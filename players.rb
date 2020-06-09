require_relative 'player'

class Players
  def initialize
    @players = [Player.new(Gosu::Color::RED),
                Player.new(Gosu::Color::BLUE),
                Player.new(Gosu::Color::YELLOW),
                Player.new(Gosu::Color::GREEN)]
    @current_player = 0
  end

  def get(num)
    @players[num] if !num.negative? && num < 4
  end

  def count
    @players.count
  end

  def next
    @current_player = (@current_player + 1) % 4
  end

  def current
    @players[@current_player]
  end

  def to_arr
    @players
  end
end
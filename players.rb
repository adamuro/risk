require_relative 'player'
require_relative 'color'
require_relative 'text'
require_relative 'common'

class Players
  def initialize
    @current = 0
    @current_player_text = Text.new(980, 660, 50)
    @current_player_text.text = 'Current player:'
    @players = [Player.new(Color::RED),
                Player.new(Color::BLUE),
                Player.new(Color::GREEN),
                Player.new(Color::YELLOW)].shuffle
  end

  def distribute_regions(map)
    all_regions = map.all_regions.shuffle
    all_regions.each_with_index { |r, i| get(i).add_region(r) }
  end

  def distribute_troops(troops = 30)
    @players.each do |player|
      player.regions.to_arr.each(&:add_troops)
      troops.times { player.regions.sample.add_troops }
    end
  end

  def get(num)
    @players[num % @players.count]
  end

  def current
    @players[@current]
  end

  def next
    @current = (@current + 1) % 4
    @players[@current].start_turn
  end

  def count
    @players.count
  end

  def draw
    Gosu.draw_rect(1220, 660, 40, 40, @players[@current].color.get)
    @current_player_text.draw
    @players.each(&:draw)
    current.draw_details
  end

  def to_arr
    @players
  end
end
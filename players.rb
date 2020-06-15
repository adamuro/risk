require_relative 'player'

class Players
  def initialize
    @players = [Player.new(Gosu::Color::RED),
                Player.new(Gosu::Color::BLUE),
                Player.new(Gosu::Color::YELLOW),
                Player.new(Gosu::Color::GREEN)].shuffle
    @current_player = 0
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
    @players[@current_player]
  end

  def next
    @current_player = (@current_player + 1) % 4
    @players[@current_player].start_turn
  end

  def count
    @players.count
  end

  def draw
    @players.each(&:draw)
  end

  def to_arr
    @players
  end
end
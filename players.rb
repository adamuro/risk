require_relative 'player'

class Players
  def initialize
    @current = 0
    @font = Gosu::Font.new(50, name: 'fonts/BebasNeue-Regular.ttf')
    @players = [Player.new(Gosu::Color::RED),
                Player.new(Gosu::Color::BLUE),
                Player.new(Gosu::Color::YELLOW),
                Player.new(Gosu::Color::GREEN)].shuffle
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
    Gosu.draw_rect(1220, 660, 40, 40, @players[@current].color)
    @font.draw_text('Current player:', 980, 660, 3)
    @players.each(&:draw)
    current.draw_details
  end

  def to_arr
    @players
  end
end
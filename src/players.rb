require_relative 'player'
require_relative 'color'
require_relative 'text'
require_relative 'common'

class Players
  def initialize
    @current = 0
    @current_player_text = Text.new(1090, 660, 50)
    @current_player_text.text = 'Current player:'
    @players = [Player.new('Red', Color::RED),
                Player.new('Blue', Color::BLUE),
                Player.new('Green', Color::GREEN),
                Player.new('Yellow', Color::YELLOW)].shuffle
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
    @current = (@current + 1) % @players.count
    @players[@current].start_turn
  end

  def count
    @players.count
  end

  def update(map)
    @players.each_with_index do |player, i|
      if player.withdraw?
        Message.withdraw(player)
        @players.delete(player)
        @current -= 1 if i < @current
      end
    end
    if !current.troops_avail? && current.phase == Phase::DRAW
      current.next_phase
    elsif current.end_turn?
      self.next
      current.territory_award(map)
    end
  end

  def draw(mouse_x, mouse_y)
    Gosu.draw_rect(1220, 660, 40, 40, @players[@current].color.get)
    @current_player_text.draw
    current.draw(mouse_x, mouse_y)
  end

  def to_arr
    @players
  end
end
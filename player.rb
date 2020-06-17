require_relative 'troops_sender'
require_relative 'regions'
require_relative 'cards'

module Phase
  DRAW = 0
  ATTACK = 1
  FORTIFY = 2
end

class Player
  attr_reader :phase, :color, :regions

  def initialize(color)
    @color = color
    @troops = 0
    @regions = Regions.new
    @cards = Cards.new
    @phase = Phase::DRAW
    @troops_sender = nil
  end

  def start_turn
    @phase = Phase::DRAW
    @troops += [@regions.count / 3, 3].max
  end

  def end_turn?
    @phase > Phase::FORTIFY
  end

  def next_phase
    @phase += 1
  end

  def add_troops(troops = 1)
    @troops += troops
  end

  def troops_avail?
    @troops.positive?
  end

  def occupy?(*regions)
    regions.flatten.all? { |r| @regions.include? r }
  end

  def territory_award(map)
    map.continents.each { |c| add_troops(c.value) if occupy?(c.regions) }
  end

  def add_region(region)
    @regions.add(region)
    region.player = self
  end

  def event(m_x, m_y)
    case @phase
    when Phase::DRAW
      if @regions.any_clicked?(m_x, m_y) && troops_avail?
        @regions.clicked(m_x, m_y).add_troops
        @troops -= 1
      end
    when Phase::ATTACK
      if @regions.any_locked?
        if @troops_sender.confirm_clicked?(m_x, m_y)
          @regions.locked_transport(@troops_sender.troops)
          @regions.unlock
          @troops_sender = nil
        else
          @troops_sender.event(m_x, m_y)
        end
      else
        if @regions.any_chosen? && @regions.chosen.enemy_neighbors.any_clicked?(m_x, m_y)
          attacked = @regions.chosen.enemy_neighbors.clicked(m_x, m_y)
          result = @regions.chosen.attack(attacked)
          if result == :victory
            @regions.lock(@regions.chosen, attacked)
            @troops_sender = TroopsSender.new(@regions.chosen.troops)
          end
        end
        @regions.unchoose_all
        @regions.choose_clicked(m_x, m_y)
      end
    when Phase::FORTIFY
      if @regions.any_locked?
        if @troops_sender.confirm_clicked?(m_x, m_y)
          @regions.locked_transport(@troops_sender.troops)
          @regions.unlock
          @troops_sender = nil
          @phase += 1
        else
          @troops_sender.event(m_x, m_y)
        end
      elsif @regions.any_chosen? && @regions.chosen.connected_allies.any_clicked?(m_x, m_y)
        fortified = @regions.chosen.connected_allies.clicked(m_x, m_y)
        @regions.lock(@regions.chosen, fortified)
        @troops_sender = TroopsSender.new(@regions.chosen.troops)
      else
        @regions.unchoose_all
        @regions.choose_clicked(m_x, m_y)
      end
      # need some way to check if any region was used to fortify in this turn
      # because you can only use one region per turn to fortify
    end
  end

  def draw
    @troops_sender.draw if @troops_sender != nil
  end

end

# think of some way to choose number of troops attacking/fortifying

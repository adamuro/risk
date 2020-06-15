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

  def event(m_x, m_y)
    case @phase
    when Phase::DRAW
      if @regions.any_clicked?(m_x, m_y) && troops_avail?
        @regions.clicked(m_x, m_y).add_troops
        @troops -= 1
      end
    when Phase::ATTACK
      if @regions.any_chosen? && @regions.chosen.enemy_neighbors.any_clicked?(m_x, m_y)
        attacked = @regions.chosen.enemy_neighbors.clicked(m_x, m_y)
        @regions.chosen.attack(attacked)
      end
      @regions.unchoose_all
      @regions.choose_clicked(m_x, m_y)
    when Phase::FORTIFY
      if @regions.any_chosen? && @regions.chosen.connected_allies.any_clicked?(m_x, m_y)
        fortified = @regions.chosen.connected_allies.clicked(m_x, m_y)
        @regions.chosen.transport_troops(fortified)
      else
        @regions.unchoose_all
        @regions.choose_clicked(m_x, m_y)
      end
      # need some way to check if any region was used to fortify in this turn
      # because you can only use one region per turn to fortify
    end
  end

  def add_region(region)
    @regions.add(region)
    region.player = self
  end

  def draw
    @regions.chosen.draw_highlighted if @regions.any_chosen?
  end
end

# think of some way to choose number of troops attacking/fortifying

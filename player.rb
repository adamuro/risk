require_relative 'regions'
require_relative 'cards'

module Phase
  DRAW = 0
  ATTACK = 1
  FORTIFY = 2
end

class Player
  attr_reader :phase, :color, :regions, :cards

  def initialize(color)
    @color = color
    @troops = 0
    @conquered = false
    @regions = Regions.new
    @cards = Cards.new
    @phase = Phase::DRAW
    @font = Gosu::Font.new(50, name: 'fonts/BebasNeue-Regular.ttf')
  end

  def start_turn
    @phase = Phase::DRAW
    @cards.draw_card if @conquered
    @conquered = false
    @troops += [@regions.count / 3, 3].max
    @regions.unchoose_all
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
      elsif @cards.exchange_clicked?(m_x, m_y) && @cards.can_exchange?
        @troops += @cards.exchange
      end
    when Phase::ATTACK
      if @regions.any_locked?
        @regions.locked_event(m_x, m_y)
      else
        if @regions.any_chosen? && @regions.chosen.enemy_neighbors.any_clicked?(m_x, m_y)
          attacked = @regions.chosen.enemy_neighbors.clicked(m_x, m_y)
          result = @regions.chosen.attack(attacked)
          if result == :victory
            @regions.lock(@regions.chosen, attacked)
            @conquered = true
          end
        end
        @regions.unchoose_all
        @regions.choose_clicked(m_x, m_y)
      end
    when Phase::FORTIFY
      if @regions.any_locked?
        #if nothing is clicked, unlock
        @phase += 1 if @regions.troops_sender.confirm_clicked?(m_x, m_y)
        @regions.locked_event(m_x, m_y)
      elsif @regions.any_chosen? && @regions.chosen.connected_allies.any_clicked?(m_x, m_y)
        fortified = @regions.chosen.connected_allies.clicked(m_x, m_y)
        @regions.lock(@regions.chosen, fortified)
        @regions.troops_sender.turn_on(@regions.chosen.troops)
      else
        @regions.unchoose_all
        @regions.choose_clicked(m_x, m_y)
      end
    end
  end

  def draw
    @regions.troops_sender.draw if @regions.any_locked?
  end

  def draw_details
    if @phase == Phase::DRAW
      @font.draw_text_rel("Troops: #{@troops}", 640, 685, 1, 0.5, 0.5)
    end
    @cards.draw
  end
end

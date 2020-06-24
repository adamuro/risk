require_relative 'regions'
require_relative 'cards'
require_relative 'text'
require_relative 'message'
require_relative 'common'

module Phase
  DRAW = 0
  ATTACK = 1
  FORTIFY = 2

  def self.to_s(phase)
    case phase
    when DRAW
      'Draw'
    when ATTACK
      'Attack'
    when FORTIFY
      'Fortify'
    end
  end
end

class Player
  attr_reader :phase, :color, :regions, :cards

  def initialize(name, color)
    @name = name
    @color = color
    @troops = 0
    @conquered = false
    @phase = Phase::DRAW
    @regions = Regions.new
    @cards = Cards.new
    @phase_text = Text.new(Window::CENTER_X, 10, 60)
    @troops_text = Text.new(Window::CENTER_X, 660, 50)
  end

  def start_turn
    @phase = Phase::DRAW
    @cards.draw_card if @conquered
    @conquered = false
    @troops += [@regions.count / 3, 3].max
    @regions.unchoose
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
    region.player.regions.delete(region) if region.has_player?
    region.player = self
  end

  def event(m_x, m_y)
    case @phase
    when Phase::DRAW
      if @regions.any_chosen? && @regions.transport_manager.clicked?(m_x, m_y)
        if @regions.transport_manager.confirm.clicked?(m_x, m_y)
          @regions.chosen.add_troops(@regions.transport_manager.troops)
          @troops -= @regions.transport_manager.troops
          Message.draw(self, @regions.transport_manager.troops, @regions.chosen)
          @regions.unchoose
        else
          @regions.transport_manager.event(m_x, m_y)
        end
      elsif @regions.any_clicked?(m_x, m_y)
        @regions.choose_clicked(m_x, m_y)
        @regions.transport_manager.turn_on(@troops + 1)
      elsif @cards.can_exchange? && @cards.exchange_clicked?(m_x, m_y)
          troops = @cards.exchange
          @troops += troops
          Message.exchange(self, troops)
      else
        @regions.unchoose
      end
    when Phase::ATTACK
      if @regions.any_transport?
        @regions.transport_event(m_x, m_y)
      else
        if @regions.any_chosen? && @regions.chosen.enemy_neighbors.any_clicked?(m_x, m_y)
          attacked = @regions.chosen.enemy_neighbors.clicked(m_x, m_y)
          result = @regions.chosen.attack(attacked)
          if result == :victory
            @regions.start_transport(@regions.chosen, attacked)
            @conquered = true
            Message.conquer(self, attacked)
          end
        end
        @regions.unchoose
        @regions.choose_clicked(m_x, m_y)
      end
    when Phase::FORTIFY
      if @regions.any_transport?
        return @regions.end_transport unless @regions.transport_manager.clicked?(m_x, m_y)
        @phase += 1 if @regions.transport_manager.confirm.clicked?(m_x, m_y)
        @regions.transport_event(m_x, m_y)
      elsif @regions.any_chosen? && @regions.chosen.connected_allies.any_clicked?(m_x, m_y)
        fortified = @regions.chosen.connected_allies.clicked(m_x, m_y)
        @regions.start_transport(@regions.chosen, fortified)
      else
        @regions.unchoose
        @regions.choose_clicked(m_x, m_y)
      end
    end
  end

  def draw(m_x, m_y)
    if @phase == Phase::DRAW
      @regions.transport_manager.draw(m_x, m_y) if @regions.any_chosen?
      @troops_text.draw("Troops: #{@troops}") unless @regions.any_chosen?
    end
    @regions.transport_manager.draw(m_x, m_y) if @regions.any_transport?
    @phase_text.draw(Phase.to_s(@phase))
    @cards.draw(m_x, m_y)
  end

  def to_s
    @name
  end
end

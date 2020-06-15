class Cards
  def initialize
    @cards = { infantry: 0, cavalry: 0, artillery: 0 }
    @values = { infantry: 4, cavalry: 6, artillery: 8, all: 10 }
  end

  def draw_card
    @cards[@cards.keys.sample] += 1
  end

  def can_exchange?
    @cards.values.any? { |v| v >= 3 } || @cards.values.all?(&:positive?)
  end

  def exchange
    if @cards.values.all?(&:positive?)
      @cards.transform_values { -1 }
      @values[:all]
    else
      @values[@cards.select { |_, v| v >= 3 }.keys.first]
    end
  end


end

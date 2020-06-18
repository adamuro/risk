class Cards
  def initialize
    @cards = { infantry: 0, cavalry: 0, artillery: 0 }
    @values = { infantry: 4, cavalry: 6, artillery: 8, all: 10 }
    @font = Gosu::Font.new(30, name: 'fonts/BebasNeue-Regular.ttf')
  end

  def draw_card
    @cards[@cards.keys.sample] += 1
  end

  def can_exchange?
    @cards.values.any? { |v| v >= 3 } || @cards.values.all?(&:positive?)
  end

  def exchange
    if @cards.values.all?(&:positive?)
      @cards.transform_values! { |v| v - 1 }
      @values[:all]
    else
      key = @cards.select { |_, v| v >= 3 }.keys.first
      @cards[key] -= 3
      @values[key]
    end
  end

  def infantry
    @cards[:infantry]
  end

  def cavalry
    @cards[:cavalry]
  end

  def artillery
    @cards[:artillery]
  end

  def draw
    @font.draw_text("Infantry: #{infantry}", 10, 560, 1)
    @font.draw_text("Cavalry: #{cavalry}", 10, 590, 1)
    @font.draw_text("Artillery: #{artillery}", 10, 620, 1)
    @font.draw_text('Exchange', 10, 650, 1) if can_exchange?
  end

  def exchange_clicked?(mouse_x, mouse_y)
    mouse_x > 10 && mouse_x < 100 && mouse_y > 650 && mouse_y < 680
  end
end

require_relative 'text_button'

class Cards
  def initialize
    @cards = { infantry: 0, cavalry: 0, artillery: 0 }
    @values = { infantry: 4, cavalry: 6, artillery: 8, all: 10 }
    @font = Gosu::Font.new(30, name: 'fonts/BebasNeue-Regular.ttf')
    @exchange_text = TextButton.new('Exchange', 16, 660, 135, 50)
    @cards_text = Text.new(35, 530, 40)
    @cards_text.text = 'Cards'
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
    @cards_text.draw
    @font.draw_text_rel("Infantry: #{infantry}", 70, 570, 1, 0.5, 0)
    @font.draw_text_rel("Cavalry: #{cavalry}", 70, 600, 1, 0.5, 0)
    @font.draw_text_rel("Artillery: #{artillery}", 70, 630, 1, 0.5, 0)
    @exchange_text.draw if can_exchange?
  end

  def exchange_clicked?(mouse_x, mouse_y)
    @exchange_text.clicked?(mouse_x, mouse_y)
  end
end

require_relative 'text_button'
require_relative 'common'

class Cards
  attr_reader :cards

  VALUES = { infantry: 4, cavalry: 6, artillery: 8, all: 10 }.freeze

  def initialize
    @cards = { infantry: 0, cavalry: 0, artillery: 0 }
    @font = Gosu::Font.new(30, name: 'fonts/BebasNeue-Regular.ttf')
    @exchange_button = TextButton.new('Exchange', 80, 660, 145, 50)
    @cards_text = Text.new(65, 530, 40)
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
      VALUES[:all]
    else
      key = @cards.select { |_, v| v >= 3 }.keys.first
      @cards[key] -= 3
      VALUES[key]
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

  def draw(mouse_x, mouse_y)
    @cards_text.draw
    @font.draw_text_rel("Infantry: #{infantry}", 70, 570, ZOrder::TEXT, 0.5, 0)
    @font.draw_text_rel("Cavalry: #{cavalry}", 70, 600, ZOrder::TEXT, 0.5, 0)
    @font.draw_text_rel("Artillery: #{artillery}", 70, 630, ZOrder::TEXT, 0.5, 0)
    @exchange_button.draw(mouse_x, mouse_y) if can_exchange?
  end

  def exchange_clicked?(mouse_x, mouse_y)
    @exchange_button.clicked?(mouse_x, mouse_y)
  end

  def merge(cards)
    @cards.merge!(cards.cards) { |_, v1, v2| v1 + v2 }
  end
end

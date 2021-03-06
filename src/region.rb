require_relative 'regions'
require_relative 'common'

class Region
  Position = Struct.new(:x, :y)

  attr_accessor :player
  attr_reader :neighbors, :troops

  def initialize(name, x, y, font_shift_x = 0, font_shift_y = 0)
    @name = name
    @troops = 0
    @player = nil
    @image = Gosu::Image.new(img_name(name))
    @position = Position.new(x, y)
    @font_pos = Position.new(@position.x + @image.width / 2 + font_shift_x,
                             @position.y + @image.height / 2 + font_shift_y)
    @font = Gosu::Font.new(20, name: 'fonts/GROBOLD.ttf')
    @neighbors = []
  end

  def attack(region)
    fighting = [self, region]
    fighting.sample.remove_troops while @troops > 1 && region.troops.positive?
    region.change_player(@player) unless region.troops.positive?
    region.troops.positive? ? :defeat : :victory
  end

  def transport_troops(region, troops = 1)
    return unless @troops > troops && troops.positive?

    region.add_troops(troops)
    @troops -= troops
  end

  def neighbor?(region)
    @neighbors.include?(region)
  end

  def add_neighbor(*regions)
    @neighbors |= regions
  end

  def enemy?(region)
    @player != region.player
  end

  def enemy_neighbors
    Regions.new(@neighbors.reject { |neighbor| neighbor.player == @player })
  end

  def ally?(region)
    @player == region.player
  end

  def ally_neighbors
    Regions.new(@neighbors.select { |neighbor| neighbor.player == @player })
  end

  def connected_allies(allies = Regions.new(self))
    until allies.to_arr.all? { |a| (a.ally_neighbors.to_arr - allies.to_arr).empty? }
      allies.add(allies.to_arr.map { |a| a.ally_neighbors.to_arr })
    end
    Regions.new(allies.without(self))
  end

  def add_troops(troops = 1)
    @troops += troops
  end

  def remove_troops(troops = 1)
    @troops -= troops
  end

  def clicked?(m_x, m_y)
    Gosu.distance(m_x, m_y, @font_pos.x, @font_pos.y) < 15
  end

  def change_player(player)
    @player.regions.delete(self)
    player.add_region(self)
  end

  def player?
    @player != nil
  end

  def draw
    @image.draw(@position.x, @position.y, ZOrder::REGION, 1, 1, @player.color.get)
    @font.draw_text_rel(@troops.to_s, @font_pos.x, @font_pos.y, ZOrder::TEXT, 0.5, 0.5)
  end

  def draw_highlighted
    @image.draw(@position.x, @position.y, ZOrder::REGION, 1, 1, @player.color.lighten)
    @font.draw_text_rel(@troops.to_s, @font_pos.x, @font_pos.y, ZOrder::TEXT, 0.5, 0.5)
  end

  def img_name(name)
    'images/map/' + name.downcase.gsub(' ', '_') + '.png'
  end

  def to_s
    @name
  end
end

require_relative 'region'
require_relative 'player'

Position = Struct.new(:x, :y)

class Continent
  attr_accessor :regions, :value

  def draw(highlighted)
    @regions.each do |r|
      if r == highlighted
        r.draw_highlighted
      else
        r.draw
      end
    end
  end
end

class NorthAmerica < Continent
  attr_accessor :alaska, :nw_territory, :greenland,
                :alberta, :ontario, :quebec,
                :west_usa, :east_usa, :mexico

  def initialize
    @value = 5
    @regions = [@alaska = Region.new('Alaska', -22, 36),
                @nw_territory = Region.new('Northwest Territory',
                                           130, -19, -60, 20),
                @greenland = Region.new('Greenland', 323, -10),
                @alberta = Region.new('Alberta', 78, 52, -20, 15),
                @ontario = Region.new('Ontario', 200, 18),
                @quebec = Region.new('Quebec', 240, 98, -15),
                @west_usa = Region.new('Western United States', 107, 124, -20),
                @east_usa = Region.new('Eastern United States', 173, 147),
                @mexico = Region.new('Mexico', 151, 211, -30, -20)]
  end

  def assign_borders_inside
    @alaska.add_neighbor(@nw_territory, @alberta)
    @nw_territory.add_neighbor(@alaska, @alberta, @ontario, @greenland)
    @greenland.add_neighbor(@nw_territory, @ontario, @quebec)
    @alberta.add_neighbor(@alaska, @nw_territory, @ontario, @west_usa)
    @ontario.add_neighbor(@nw_territory, @greenland, @alberta, @west_usa, @east_usa, @quebec)
    @quebec.add_neighbor(@greenland, @ontario, @east_usa)
    @west_usa.add_neighbor(@alberta, @ontario, @east_usa, @mexico)
    @east_usa.add_neighbor(@quebec, @ontario, @west_usa, @mexico)
    @mexico.add_neighbor(@west_usa, @east_usa)
  end
end

class SouthAmerica < Continent
  attr_accessor :colombia, :peru, :brazil, :argentina

  def initialize
    @value = 2
    @regions = [@colombia = Region.new('Colombia', 247, 281),
                @peru = Region.new('Peru', 231, 349, -5),
                @brazil = Region.new('Brazil', 292, 361),
                @argentina = Region.new('Argentina', 248, 459, -5, -30)]
  end

  def assign_borders_inside
    @colombia.add_neighbor(@peru, @brazil)
    @peru.add_neighbor(@colombia, @brazil, @argentina)
    @brazil.add_neighbor(@colombia, @peru, @argentina)
    @argentina.add_neighbor(@peru, @brazil)
  end
end

class Europe < Continent
  attr_accessor :iceland, :gr_britain, :scandinavia,
                :w_europe, :e_europe, :balkans

  def initialize
    @value = 5
    @regions = [@iceland = Region.new('Iceland', 397, 38),
                @gr_britain = Region.new('Great Britain', 442, 78),
                @scandinavia = Region.new('Scandinavia', 532, 41, 20, -10),
                @w_europe = Region.new('Western Europe', 455, 124),
                @e_europe = Region.new('Eastern Europe', 531, 82, 15),
                @balkans = Region.new('Balkans', 526, 121, 0, 5)]
  end

  def assign_borders_inside
    @iceland.add_neighbor(@gr_britain, @scandinavia)
    @gr_britain.add_neighbor(@iceland, @scandinavia, @w_europe)
    @scandinavia.add_neighbor(@iceland, @gr_britain, @e_europe)
    @w_europe.add_neighbor(@gr_britain, @e_europe, @balkans)
    @e_europe.add_neighbor(@scandinavia, @w_europe, @balkans)
    @balkans.add_neighbor(@w_europe, @e_europe)
  end
end

class Africa < Continent
  attr_accessor :w_africa, :egypt, :e_africa,
                :congo, :s_africa, :madagascar

  def initialize
    @value = 3
    @regions = [@w_africa = Region.new('Western Africa', 465, 224),
                @egypt = Region.new('Egypt', 533, 204),
                @e_africa = Region.new('Eastern Africa', 575, 285),
                @congo = Region.new('Congo', 519, 311),
                @s_africa = Region.new('South Africa', 535, 378),
                @madagascar = Region.new('Madagascar', 611, 369)]
  end

  def assign_borders_inside
    @w_africa.add_neighbor(@egypt, @e_africa, @congo)
    @egypt.add_neighbor(@w_africa, @e_africa)
    @e_africa.add_neighbor(@w_africa, @egypt, @congo, @s_africa, @madagascar)
    @congo.add_neighbor(@w_africa, @e_africa, @s_africa)
    @s_africa.add_neighbor(@e_africa, @congo, @madagascar)
    @madagascar.add_neighbor(@e_africa, @s_africa)
  end
end

class Asia < Continent
  attr_accessor :w_asia, :ural, :w_siberia, :e_siberia, :kamchatka,
                :mongolia, :arabian_p, :kazakhstan, :china,
                :gobi_desert, :japan, :india, :indochina_p, :indonesia

  def initialize
    @value = 7
    @regions = [@w_asia = Region.new('Western Asia', 618, 76),
                @ural = Region.new('Ural', 703, 57, -15),
                @w_siberia = Region.new('Western Siberia', 752, 39),
                @e_siberia = Region.new('Eastern Siberia', 848, 24, -5, -10),
                @kamchatka = Region.new('Kamchatka', 975, 58, -10, -20),
                @mongolia = Region.new('Mongolia', 838, 70, 15),
                @arabian_p = Region.new('Arabian Peninsula', 616, 195),
                @kazakhstan = Region.new('Kazakhstan', 674, 126),
                @china = Region.new('China', 791, 163),
                @gobi_desert = Region.new('Gobi Desert', 843, 124, 15),
                @japan = Region.new('Japan', 912, 159, 5),
                @india = Region.new('India', 720, 210),
                @indochina_p = Region.new('Indochina Peninsula', 784, 228),
                @indonesia = Region.new('Indonesia', 818, 305, 18, -7)]
  end

  def assign_borders_inside
    @w_asia.add_neighbor(@ural, @arabian_p, @kazakhstan)
    @ural.add_neighbor(@w_asia, @w_siberia, @kazakhstan, @china)
    @w_siberia.add_neighbor(@ural, @e_siberia, @mongolia, @china, @gobi_desert)
    @e_siberia.add_neighbor(@w_siberia, @kamchatka, @mongolia)
    @kamchatka.add_neighbor(@e_siberia, @mongolia, @gobi_desert, @japan)
    @mongolia.add_neighbor(@w_siberia, @e_siberia, @kamchatka, @gobi_desert)
    @arabian_p.add_neighbor(@w_asia, @kazakhstan, @india)
    @kazakhstan.add_neighbor(@w_asia, @ural, @arabian_p, @china, @india)
    @china.add_neighbor(@ural, @w_siberia, @gobi_desert, @japan, @kazakhstan, @india, @indochina_p)
    @gobi_desert.add_neighbor(@w_siberia, @kamchatka, @mongolia, @china, @japan)
    @japan.add_neighbor(@kamchatka, @gobi_desert, @china)
    @india.add_neighbor(@arabian_p, @kazakhstan, @china, @indochina_p)
    @indochina_p.add_neighbor(@india, @china, @indonesia)
    @indonesia.add_neighbor(@indochina_p)
  end
end

class Australia < Continent
  attr_accessor :w_australia, :e_australia, :pn_guinea

  def initialize
    @value = 2
    @regions = [@w_australia = Region.new('Western Australia', 872, 386),
                @e_australia = Region.new('Eastern Australia', 928, 398, 10),
                @pn_guinea = Region.new('Papua New Guinea', 924, 319)]
  end

  def assign_borders_inside
    @w_australia.add_neighbor(@e_australia, @pn_guinea)
    @e_australia.add_neighbor(@w_australia, @pn_guinea)
    @pn_guinea.add_neighbor(@w_australia, @e_australia)
  end
end
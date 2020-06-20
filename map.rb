require_relative 'continent'
require_relative 'common'

class Map
  attr_accessor :continents, :n_america

  def initialize
    @background = Gosu::Image.new('images/map/map.png')
    @continents = [@n_america = NorthAmerica.new,
                   @s_america = SouthAmerica.new,
                   @europe = Europe.new,
                   @africa = Africa.new,
                   @asia = Asia.new,
                   @australia = Australia.new]
    assign_borders
  end

  def all_regions
    @continents.each.inject([]) { |all, continent| all.concat(continent.regions) }
  end

  def assign_borders
    @continents.each(&:assign_borders_inside)
    assign_n_america_borders
    assign_s_america_borders
    assign_europe_borders
    assign_africa_borders
    assign_asia_borders
    assign_australia_borders
  end

  def assign_n_america_borders
    @n_america.greenland.add_neighbor(@europe.iceland)
    @n_america.mexico.add_neighbor(@s_america.colombia)
    @n_america.alaska.add_neighbor(@asia.kamchatka)
  end

  def assign_s_america_borders
    @s_america.colombia.add_neighbor(@n_america.mexico)
    @s_america.brazil.add_neighbor(@africa.w_africa)
  end

  def assign_europe_borders
    @europe.iceland.add_neighbor(@n_america.greenland)
    @europe.w_europe.add_neighbor(@africa.w_africa)
    @europe.scandinavia.add_neighbor(@asia.w_asia)
    @europe.e_europe.add_neighbor(@asia.w_asia)
    @europe.balkans.add_neighbor(@africa.egypt, @asia.w_asia, @asia.arabian_p)
  end

  def assign_africa_borders
    @africa.w_africa.add_neighbor(@europe.w_europe, @s_america.brazil)
    @africa.egypt.add_neighbor(@europe.balkans, @asia.arabian_p)
    @africa.e_africa.add_neighbor(@asia.arabian_p)
  end

  def assign_asia_borders
    @asia.w_asia.add_neighbor(@europe.scandinavia, @europe.e_europe, @europe.balkans)
    @asia.kamchatka.add_neighbor(@n_america.alaska)
    @asia.arabian_p.add_neighbor(@europe.balkans, @africa.egypt, @africa.e_africa)
    @asia.indonesia.add_neighbor(@australia.w_australia, @australia.pn_guinea)
  end

  def assign_australia_borders
    @australia.w_australia.add_neighbor(@asia.indonesia)
    @australia.pn_guinea.add_neighbor(@asia.indonesia)
  end

  def draw(highlighted)
    @background.draw(0, 0, ZOrder::BACKGROUND)
    @continents.each { |c| c.draw(highlighted)}
  end
end

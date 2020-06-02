require_relative 'continent'

class Map
  def initialize
    @image = Gosu::Image.new('images/map.png')
    @continents = [@n_america = NorthAmerica.new,
                   @s_america = SouthAmerica.new,
                   @europe = Europe.new,
                   @africa = Africa.new,
                   @asia = Asia.new]
    assign_borders
  end

  def assign_borders
    @continents.each(&:assign_inside_borders)
    @n_america.greenland.add_neighbor(@europe.iceland)
    @n_america.mexico.add_neighbor(@s_america.colombia)
    @n_america.alaska.add_neighbor(@asia.kamchatka)
    @s_america.colombia.add_neighbor(@n_america.mexico)
    @s_america.brazil.add_neighbor(@africa.w_africa)
    @europe.iceland.add_neighbor(@n_america.greenland)
    @europe.w_europe.add_neighbor(@africa.w_africa)
    @europe.scandinavia.add_neighbor(@asia.w_asia)
    @europe.e_europe.add_neighbor(@asia.w_asia)
    @europe.balkans.add_neighbor(@africa.egypt, @asia.w_asia, @asia.arabian_p)
    @africa.w_africa.add_neighbor(@europe.w_europe, @s_america.brazil)
    @africa.egypt.add_neighbor(@europe.balkans, @asia.arabian_p)
    @africa.e_africa.add_neighbor(@asia.arabian_p)
    @asia.w_asia.add_neighbor(@europe.scandinavia, @europe.e_europe, @europe.balkans)
    @asia.arabian_p.add_neighbor(@europe.balkans, @africa.egypt, @africa.e_africa)
    @asia.kamchatka.add_neighbor(@n_america.alaska)
  end

  def draw
    @image.draw(0, 0, 0)
    @continents.each(&:draw)
  end
end

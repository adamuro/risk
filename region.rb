require_relative 'common'

class Region
  Position = Struct.new(:x, :y)
  def initialize(name, position)
    @name = name
    @position = position
    @image = Gosu::Image.new(img_name(name))
    @soldiers = 0
    @color = Gosu::Color::RED
  end

  def draw
    @image.draw(@position.x, @position.y, 1, 1, 1, @color)
  end
end

class Alaska < Region
  def initialize
    super('Alaska', Position.new(-22, 36))
  end
end

class NorthwestTerritory < Region
  def initialize
    super('Northwest Territory', Position.new(130, -19))
  end
end

class Alberta < Region
  def initialize
    super('Alberta', Position.new(78, 52))
  end
end

class Ontario < Region
  def initialize
    super('Ontario', Position.new(200, 18))
  end
end

class Quebec < Region
  def initialize
    super('Quebec', Position.new(240, 98))
  end
end

class WesternUnitedStates < Region
  def initialize
    super('Western United States', Position.new(107, 124))
  end
end

class EasternUnitedStates < Region
  def initialize
    super('Eastern United States', Position.new(173, 147))
  end
end

class Mexico < Region
  def initialize
    super('Mexico', Position.new(151, 211))
  end
end

class Colombia < Region
  def initialize
    super('Colombia', Position.new(247, 281))
  end
end

class Peru < Region
  def initialize
    super('Peru', Position.new(231, 349))
  end
end

class Brasil < Region
  def initialize
    super('Brasil', Position.new(292, 361))
  end
end

class Argentina < Region
  def initialize
    super('Argentina', Position.new(248, 459))
  end
end
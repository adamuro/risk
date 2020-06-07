module Phase
  DRAW = 0
  ATTACK = 1
  FORTIFY = 2

  def next_phase
    @phase += 1
  end
end

class Player
  include Phase

  def initialize(color)
    @color = color
    @regions = []
    @phase = Phase::DRAW
  end

  def add_region(region)
    @regions << region
    region.color = @color
  end
end
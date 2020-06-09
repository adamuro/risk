module Phase
  DRAW = 0
  ATTACK = 1
  FORTIFY = 2
end

class Player
  attr_accessor :regions
  attr_reader :phase, :troops

  def initialize(color)
    @color = color
    @regions = []
    @chosen_region = nil
    @troops = 0
    @phase = Phase::DRAW
  end

  def start_turn
    @phase = Phase::DRAW
    @troops += @regions.count / 3
  end

  def end_turn?
    @phase > Phase::FORTIFY
  end

  def next_phase
    @phase += 1
  end

  def add_troops(troops = 1)
    @troops += troops
  end

  def troops_avail?
    @troops.positive?
  end

  def occupy?(*regions)
    regions.flatten.each do |region|
      return false unless @regions.include?(region)
    end
    true
  end

  def event(mouse_x, mouse_y)
    case @phase
    when Phase::DRAW
      @regions.each do |region|
        if region.clicked?(mouse_x, mouse_y) && troops_avail?
          region.add_troops
          @troops -= 1
        end
      end
      # check if player's region was clicked, if so:
        # add one troop to the region
    when Phase::ATTACK
      # check if player's region was clicked, if so:
        # if it was chosen: set chosen region to none
        # else: set it as the chosen region
      # check if any region is chosen, if so:
        # check if any of its enemy neighbors was clicked if so:
          # attack the clicked neighbor
    when Phase::FORTIFY
      # check if player's region was clicked, if so:
        # if it was chosen: set chosen region to none
        # else: set it as the chosen region
      # check if any region is chosen, if so:
        # check if any of player's other regiuons was clicked if so:
          # check if the chosen region is connected to the clicked region, if so:
            # transport one troop to the clicked region, if possible
      # need some way to check if any region was used to fortify in this turn
      # because you can only use one region per turn to fortify
    end
  end

  def add_region(region)
    @regions << region
    region.color = @color
  end

  def rand_region
    @regions.sample
  end
end

# think of some way to choose number of troops attacking/fortifying

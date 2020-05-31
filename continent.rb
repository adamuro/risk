require_relative 'common'
require_relative 'region'

module Continent
  def draw
    @regions.each(&:draw)
  end
end

class NorthAmerica
  include Continent

  def initialize
    @regions = [Alaska.new,
                NorthwestTerritory.new,
                Alberta.new,
                Ontario.new,
                Quebec.new,
                WesternUnitedStates.new,
                EasternUnitedStates.new,
                Mexico.new]
  end
end

class SouthAmerica
  include Continent

  def initialize
    @regions = [Colombia.new,
                Peru.new,
                Brasil.new,
                Argentina.new]
  end
end
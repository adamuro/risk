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
    @regions = [Alaska.new]
  end
end
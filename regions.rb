require_relative 'region'

class Regions
  attr_reader :chosen, :locked

  def initialize(regions = [])
    @regions = regions
    @chosen = nil
    @locked = []
  end

  def count
    @regions.count
  end

  def add(*regions)
    @regions |= regions.flatten
  end

  def include?(region)
    @regions.include?(region)
  end

  def clicked(mouse_x, mouse_y)
    @regions.select { |r| r.clicked?(mouse_x, mouse_y) }.first
  end

  def any_clicked?(mouse_x, mouse_y)
    @regions.any? { |r| r.clicked?(mouse_x, mouse_y) }
  end

  def choose(region)
    @chosen = region
  end

  def choose_clicked(m_x, m_y)
    choose(clicked(m_x, m_y)) if any_clicked?(m_x, m_y)
  end

  def unchoose_all
    @chosen = nil
  end

  def any_chosen?
    @chosen != nil
  end

  def lock(transporter, receiver)
    @locked = [transporter, receiver]
  end

  def unlock
    @locked = []
  end

  def any_locked?
    !@locked.empty?
  end

  def transporter
    @locked.first unless @locked.empty?
  end

  def receiver
    @locked.last unless @locked.empty?
  end

  def locked_transport(troops)
    transporter.transport_troops(receiver, troops)
  end

  def to_arr
    @regions
  end

  def without(region)
    @regions - [region]
  end

  def sample
    @regions.sample
  end
end
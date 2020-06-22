require_relative 'region'
require_relative 'troops_sender'

class Regions
  attr_reader :chosen, :locked, :troops_sender

  def initialize(*regions)
    @regions = regions.flatten
    @chosen = nil
    @locked = []
    @troops_sender = TroopsSender.new
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
    @troops_sender.turn_on(transporter.troops)
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

  def locked_event(m_x, m_y)
    if @troops_sender.confirm.clicked?(m_x, m_y)
      transporter.transport_troops(receiver, @troops_sender.troops)
      unlock
    else
      @troops_sender.event(m_x, m_y)
    end
  end

  def map(func)
    @regions.map { |region| func.call(region) }
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
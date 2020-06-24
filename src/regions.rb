require_relative 'region'
require_relative 'transport_manager'

class Regions
  attr_reader :chosen, :transport, :transport_manager

  def initialize(*regions)
    @regions = regions.flatten
    @chosen = nil
    @transport = []
    @transport_manager = TransportManager.new
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

  def unchoose
    @chosen = nil
  end

  def any_chosen?
    @chosen != nil
  end

  def start_transport(transporter, receiver)
    @transport_manager.turn_on(transporter.troops)
    @transport = [transporter, receiver]
  end

  def end_transport
    @transport = []
  end

  def any_transport?
    !@transport.empty?
  end

  def transporter
    @transport.first unless @transport.empty?
  end

  def receiver
    @transport.last unless @transport.empty?
  end

  def transport_event(m_x, m_y)
    if @transport_manager.confirm.clicked?(m_x, m_y)
      Message.fortify(transporter, @transport_manager.troops, receiver)
      transporter.transport_troops(receiver, @transport_manager.troops)
      end_transport
    else
      @transport_manager.event(m_x, m_y)
    end
  end

  def map(func)
    @regions.map { |region| func.call(region) }
  end

  def to_arr
    @regions
  end

  def delete(region)
    @regions.delete(region)
  end

  def without(region)
    @regions - [region]
  end

  def sample
    @regions.sample
  end
end
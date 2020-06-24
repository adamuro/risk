module Message
  def self.draw(player, troops, region)
    puts "#{player} draws #{troops} troops to #{region}."
  end

  def self.conquer(conqueror, conquered)
    puts "#{conqueror} conquers #{conquered}."
  end

  def self.fortify(transporter, troops, receiver)
    puts "#{transporter.player} transports #{troops} troops from #{transporter} to #{receiver}."
  end

  def self.exchange(player, troops)
    puts "#{player} exchanges cards and gains #{troops} troops"
  end

  def self.withdraw(player)
    puts "#{player} withdraws."
  end
end
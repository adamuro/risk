class Logo
  def initialize()
    @img = Gosu::Image.new('images/main_menu/logo.png')
  end

  def draw(width, y = 0)
    @img.draw(width / 2 - @img.width / 2, y, 1)
  end
end
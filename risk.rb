require 'gosu'
require_relative 'main_menu'
require_relative 'game'

class Risk < Gosu::Window
  def initialize
    super(1280, 720)
    self.caption = 'Risk'
    @main_menu = MainMenu.new(self)
    @game = Game.new(self)
    @window = @game
  end

  def needs_cursor?
    true
  end

  def update
    close if Gosu.button_down? Gosu::KB_ESCAPE
  end

  def draw
    @window.draw
  end
end

Risk.new.show if __FILE__ == $PROGRAM_NAME

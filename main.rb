require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Game Dev"

    @ball = Gosu::Image.new self, "resources/images/ball.png", true
  end

  def update
  end

  def draw
    @ball.draw 0, 0, 0
  end
end

window = GameWindow.new
window.show

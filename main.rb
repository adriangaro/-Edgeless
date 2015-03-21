require 'gosu'
require_relative 'player'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Game Dev"

    @ball = Player.new self
  end

  def update
    @ball.warp 150, 50
  end

  def draw
    @ball.draw
  end
end

window = GameWindow.new
window.show

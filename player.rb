require 'gosu'

class Player
  def initialize(window)
    @image = Gosu::Image.new window, "resources/images/ball.png"
    @x, @y = 100, 100
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def draw
    @image.draw @x, @y, 0
  end
end

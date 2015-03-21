require 'gosu'

class Player
  def initialize(window)
    @image = Gosu::Image.new window, "resources/images/ball.png"
  end
end

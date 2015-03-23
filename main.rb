require 'gosu'
require 'chipmunk'
require_relative 'chip-gosu-functions'
require_relative 'player'



class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Game Dev"

    @dt = 1.0/60.0

    @space = CP::Space.new
    @space.damping = 0.8

    @ball = Player.new self
    @ball2 = Player.new self

    @space.add_body @ball.body
    @space.add_shape @ball.shape
    @space.add_body @ball2.body
    @space.add_shape @ball2.shape

    @ball.warp CP::Vec2.new(320, 240)
    @ball2.warp CP::Vec2.new(520, 190)
  end

  def update
    SUBSTEPS.times do
      @ball.shape.body.reset_forces
      @ball2.shape.body.reset_forces

      @ball.validate_position
      @ball2.validate_position

      if button_down? Gosu::KbLeft
        @ball.turn_left
        @ball.accelerate_left
      end

      if button_down? Gosu::KbRight
        @ball.turn_right
        @ball.accelerate_right
      end

      #if button_down? Gosu::KbUp
      #  if ( (button_down? Gosu::KbRightShift) || (button_down? Gosu::KbLeftShift) )
      #    @ball.boost
      #  else
      #    @ball.accelerate
      #  end
      #end
      @space.step(@dt)
    end
  end

  def draw
    @ball.draw
    @ball2.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

window = GameWindow.new
window.show

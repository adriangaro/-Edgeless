require 'gosu'
require 'chipmunk'
require_relative 'player'
require_relative 'obj'
require_relative 'platform'
require_relative 'chip-gosu-functions'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Game Dev"

    @dt = (1.0/60.0)

    @objects = []

    @space = CP::Space.new
    @space.damping = 0.8

    @player = Player.new self, true, "resources/images/ball.png"
    @platform = Platform.new self, false, "resources/images/platform.png", 320, 50
    @platform2 = Platform.new self, false, "resources/images/platform.png", 320, 50, 20
    @platform3 = Platform.new self, false, "resources/images/platform.png", 320, 50, -20

    @space.add_body(@player.body)
    @space.add_body(@platform.body)
    @space.add_body(@platform2.body)
    @space.add_body(@platform3.body)

    @space.add_shape(@player.shape)
    @space.add_shape(@platform.shape)
    @space.add_shape(@platform2.shape)
    @space.add_shape(@platform3.shape)

    @objects << @player
    @objects << @platform
    @objects << @platform2
    @objects << @platform3

    @player.warp CP::Vec2.new 520, 240
    @platform.warp CP::Vec2.new 0, 300
    @platform2.warp CP::Vec2.new 320, 300
    @platform3.warp CP::Vec2.new 320, 410

    @space.add_collision_handler :ball, :platform, PlayerCollisionHandler.new(@player)
  end

  def update
    SUBSTEPS.times do
      @player.shape.body.reset_forces

      @player.validate_position

      if button_down? Gosu::KbLeft
        @player.turn_left
        @player.accelerate_left
      end

      if button_down? Gosu::KbSpace
        @player.jump
      end

      if button_down? Gosu::KbRight
        @player.turn_right
        @player.accelerate_right
      end

      @objects.each do |obj|
        obj.do_gravity(400.0)
      end

      @space.step(@dt)
    end
  end

  def draw
    @objects.each do |obj|
      obj.draw
    end
  end

  class PlayerCollisionHandler
    def initialize(player)
      @player = player
    end

    def begin(a, b, arbiter)
      @player.j = true
      true
    end

    def pre_solve(a, b)
      true
    end

    def post_solve(arbiter)
      true
    end

    def separate
      @player.j = false
    end
  end
end

window = GameWindow.new
window.show

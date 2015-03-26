require 'gosu'
require 'chipmunk'

require_relative 'player'
require_relative 'spike'
require_relative 'obj'
require_relative 'collision-handlers'
require_relative 'platform'
require_relative 'platform_poly'
require_relative 'chip-gosu-functions'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = 'Edgeless'

    @dt = 1.0 / 60.0

    @objects = []

    @space = CP::Space.new
    @space.damping = 0.8

    @player = Player.new self, true, 30
    @platform = Platform.new self, false, 320, 50
    @platform2 = Platform.new self, false, 320, 50, 20
    @platform3 = Platform.new self, false, 320, 50, -20
    @spikes = Spike.new self, false, 200, 100
    @poly = PlatformPoly.new self,
                             false,
                             [CP::Vec2.new(-50.0, 0.0),
                              CP::Vec2.new(-100, 0.0),
                              CP::Vec2.new(-100, 175),
                              CP::Vec2.new(-50.0, 200),
                              CP::Vec2.new(0.0, 75)]

    @objects << @player
    @objects << @platform
    @objects << @platform2
    @objects << @platform3
    @objects << @spikes
    @objects << @poly

    @objects.each do |obj|
      obj.add_to_space @space
    end

    @player.warp CP::Vec2.new 520, 240
    @platform.warp CP::Vec2.new 0, 300
    @platform2.warp CP::Vec2.new 320, 300
    @platform3.warp CP::Vec2.new 320, 410
    @spikes.warp CP::Vec2.new 100, 200
    @poly.warp CP::Vec2.new 400, 100

    @space.add_collision_handler :ball,
                                 :platform,
                                 PlayerPlatformCollisionHandler.new(@player)
    @space.add_collision_handler :ball,
                                 :platform_poly,
                                 PlayerPlatformPolyCollisionHandler.new(@player)
    @space.add_collision_handler :ball,
                                 :spikes_p,
                                 PlayerSpikeCollisionHandler.new(@player)
  end

  def update
    SUBSTEPS.times do
      @player.shapes[0].body.reset_forces

      @player.validate_position

      if button_down? Gosu::KbLeft
        @player.turn_left
        @player.accelerate_left
      end
      if button_down? Gosu::KbRight
        @player.turn_right
        @player.accelerate_right
      end

      @player.jump if button_down? Gosu::KbSpace

      @objects.each do |obj|
        obj.do_gravity 400.0
      end
      @space.step @dt
    end
  end

  def draw
    @objects.each do |obj|
      obj.draw
    end
  end
end

window = GameWindow.new
window.show

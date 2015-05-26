require 'gosu'
require 'chipmunk'

require_relative 'level'
require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../objects/platform'
require_relative '../objects/jump_pad'
require_relative '../objects/util/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/utility'
require_relative '../objects/util/level_background'
require_relative '../objects/mob/player'
require_relative '../objects/mob/square_mob'
require_relative '../objects/mob/triangle_mob'


class First < Level
  def initialize(window)
    super window, 2000, 480
    @space.damping = 0.8
    @space.gravity = vec2 0, 20
  end

  def declare_obj
    @player = Player.new @window
    @poly = PlatformPoly.new @window,
                             [vec2(-50.0, 0.0),
                              vec2(-50.0, 2000.0),
                              vec2(0, 2000.0),
                              vec2(0, 0)]

    @jump_pad = JumpPad.new @window, 100, 45

    @square_mob = SquareMob.new @window

    @triangle_mob = TriangleMob.new @window

    @background1 = LevelBackground.new @window,
                                       "resources/images/background1.png",
                                       640,
                                       480
    @background2 = LevelBackground.new @window,
                                       "resources/images/background2.png",
                                       560,
                                       480
    @background3 = LevelBackground.new @window,
                                       "resources/images/background3.png",
                                       800,
                                       480
  end

  def add_objects
    @mobs << @player
    @objects << @poly
    @objects << @jump_pad
    @mobs << @square_mob
    @mobs << @triangle_mob
    @backgrounds << @background1
    @backgrounds << @background2
    @backgrounds << @background3
  end

  def warp
    @player.warp vec2 120, 140
    @poly.warp vec2 0, 400
    @jump_pad.warp vec2 1800, 350
    @square_mob.warp vec2 300, 300
    @triangle_mob.warp vec2 400, 300
    @background1.warp vec2 0, 0
    @background2.warp vec2 640, 0
    @background3.warp vec2 1200, 0
  end
end

require 'gosu'
require 'chipmunk'

require_relative 'level'
require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../objects/platform'
require_relative '../objects/jump_pad'
require_relative '../objects/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/utility'
require_relative '../objects/level_background'
require_relative '../objects/mob/player'
require_relative '../objects/mob/square_mob'


class Test < Level
  def initialize(window)
    super window
    @space.damping = 0.8
    @space.gravity = vec2 0, 20
  end

  def declare_obj
    @player = Player.new @window, 50

    @platform1 = PlatformPoly.new @window,
                                  [vec2(-50.0, 0.0),
                                   vec2(-50.0, 600.0),
                                   vec2(0, 600.0),
                                   vec2(0, 0)]
    @platform2 = PlatformPoly.new @window,
                                  [vec2(-50.0, 0.0),
                                   vec2(-50.0, 400.0),
                                   vec2(0, 400.0),
                                   vec2(0, 0)]

    @platform3 = PlatformPoly.new @window,
                                  [vec2(-50.0, 0.0),
                                   vec2(-50.0, 200.0),
                                   vec2(0, 0)]

    @jump_pad1 = JumpPad.new @window, 150, 0, Gosu::Color.new(234, 156, 63)

    @square_mob = SquareMob.new @window, vec2(1100, 500)

    @level_border = LevelBorder.new @window, 1200, 800

    @background1 = LevelBackground.new @window,
                                       "resources/images/background1.png",
                                       600,
                                       400

    @background2 = LevelBackground.new @window,
                                       "resources/images/background2.png",
                                       600,
                                       400

    @background3 = LevelBackground.new @window,
                                       "resources/images/background3.png",
                                       1200,
                                       400
  end

  def add_objects
    @objects << @platform1
    @objects << @platform2
    @objects << @platform3
    @objects << @jump_pad1
    @objects << @level_border

    @mobs << @player
    @mobs << @square_mob

    @backgrounds << @background1
    @backgrounds << @background2
    @backgrounds << @background3
  end

  def warp
    @platform1.warp vec2 0, 750
    @platform2.warp vec2 800, 550
    @platform3.warp vec2 0, 450

    @jump_pad1.warp vec2 400, 750

    @level_border.warp vec2 0, 0

    @player.warp vec2 50, 200
    @square_mob.warp vec2 900, 500

    @background1.warp vec2 0, 400
    @background2.warp vec2 600, 400
    @background3.warp vec2 0, 0
  end

end

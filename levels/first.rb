require 'gosu'
require 'chipmunk'

require_relative 'level'
require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../utility/collision-handlers'
require_relative '../objects/platform'
require_relative '../objects/spring'
require_relative '../objects/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/chip-gosu-functions'
require_relative '../objects/level_background'
require_relative '../objects/mob/player'
require_relative '../objects/mob/square_mob'


class First < Level
  def initialize(window)
    super window
    @space.damping = 0.8
    @space.gravity = vec2 0, 20
  end

  def declare_obj
    @player = Player.new @window, 30
    @poly = PlatformPoly.new @window,
                             [vec2(-50.0, 0.0),
                              vec2(-50.0, 1200.0),
                              vec2(0, 1200.0),
                              vec2(0, 0)]
    @level_border = LevelBorder.new @window, 1200, 480

    @platform1 = Platform.new @window, 300, 50, -30

    @spring = Spring.new @window, 200

    @square_mob = SquareMob.new @window, vec2(500, 300)

    @background1 = LevelBackground.new @window,
                                       "resources/images/background1.png",
                                       640,
                                       480
    @background2 = LevelBackground.new @window,
                                       "resources/images/background2.png",
                                       560,
                                       480
  end

  def add_objects
    @mobs << @player
    @objects << @poly
    @objects << @level_border
    @objects << @spring
    @objects << @platform1
    @mobs << @square_mob
    @backgrounds << @background1
    @backgrounds << @background2
  end

  def warp
    @player.warp vec2 120, 140
    @poly.warp vec2 0, 400
    @spring.warp vec2 900, 450
    @platform1.warp vec2 400, 400
    @level_border.warp vec2 0, 0
    @square_mob.warp vec2 300, 300
    @background1.warp vec2 0, 0
    @background2.warp vec2 640, 0
  end
end

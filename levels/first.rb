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
    super window, 2000, 800
    @space.damping = 0.8

    warp_player 120, 140
    add_object PlatformPoly.new(@window,
                                [vec2(-50.0, 0.0),
                                 vec2(-50.0, 2000.0),
                                 vec2(0, 2000.0),
                                 vec2(0, 0)]),
               0, 600

    add_object JumpPad.new(@window, 100, 0, Gosu::Color.new(234, 156, 63)), 0, 600

    add_mob SquareMob.new(@window), 300, 300

    add_mob TriangleMob.new(@window), 400, 300

    add_background LevelBackground.new(@window, 'background1', 640, 800), 0, 0

    add_background LevelBackground.new(@window, 'background2', 560, 800), 640, 0

    add_background LevelBackground.new(@window, 'background3', 800, 800), 1200, 0

    init_level
  end
end

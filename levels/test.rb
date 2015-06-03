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


class Test < Level
  def initialize(window)
    super window, 3000, 800
    @space.damping = 0.8
    @gravity = vec2 0, 20
    @space.gravity = @gravity

    warp_player 50, 200

    add_object PlatformPoly.new(@window,
                                [vec2(-50.0, 0.0),
                                 vec2(-50.0, 800.0),
                                 vec2(0, 800.0),
                                 vec2(0, 0)]),
               0, 750

    add_object PlatformPoly.new(@window,
                                [vec2(-50.0, 0.0),
                                 vec2(-50.0, 600.0),
                                 vec2(0, 400.0),
                                 vec2(0, 0)]),
               800, 550

    add_object PlatformPoly.new(@window,
                                [vec2(-50.0, 0.0),
                                 vec2(-50.0, 200.0),
                                 vec2(0, 0)]),
               0, 450

    add_object JumpPad.new(@window, 150, 0, Gosu::Color.new(234, 156, 63)), 400, 750

    add_mob SquareMob.new(@window), 900, 500

    add_background LevelBackground.new(@window, 'background1', 700, 500), 0, 300

    add_background LevelBackground.new(@window, 'background2', 500, 500), 700, 300

    add_background LevelBackground.new(@window, 'background3', 1200, 300), 0, 0

    init_level
  end
end

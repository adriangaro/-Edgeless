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

    add_object JumpPad.new(@window, 100, 0, Assets[0xff_ea9c3f, :color]), 0, 600

    add_mob SquareMob.new(@window), 300, 300

    add_mob TriangleMob.new(@window), 400, 300

    add_background LevelBackground.new(@window, 'background1', 640, 800), 0, 0

    add_background LevelBackground.new(@window, 'background2', 560, 800), 640, 0

    add_background LevelBackground.new(@window, 'background3', 800, 800), 1200, 0

    add_trigger SummonTrigger.new(700, 600, [[SquareMob, 5], [TriangleMob, 2], [SquareMob, 2]], 300, 100, 30, "Bravo Fa!", true, 'prin'), :summon_1

    add_trigger MoveTrigger.new(300, 600, 100, "Venisi fa aici cum sa nu vii!", true, 'prin'), :move_1

    add_trigger KillTrigger.new([@mobs[1], @mobs[2]], "Killed targets!", true, 'prin'), :kill_1

    @triggers[:summon_1].add_child(@triggers[:kill_1])
    @triggers[:move_1].add_child(@triggers[:summon_1])
    init_level
  end
end

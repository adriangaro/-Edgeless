require 'gosu'
require 'chipmunk'

require_relative 'level'
require_relative '../player'
require_relative '../spike'
require_relative '../obj'
require_relative '../collision-handlers'
require_relative '../platform'
require_relative '../level_border'
require_relative '../platform_poly'
require_relative '../chip-gosu-functions'

class First < Level
  def initialize(window)
    super window
    @space.damping = 0.8
    declare_obj
    add_objects
    add_to_space
    warp
  end

  def declare_obj
    @player = Player.new @window, true, 30
    @poly = PlatformPoly.new @window,
                             false,
                             [vec2(-50.0, 0.0),
                              vec2(-50.0, 1200.0),
                              vec2(0, 1200.0),
                              vec2(0, 0)]
    @level_border = LevelBorder.new @window, 1200, 480
  end

  def add_objects
    @objects << @player
    @objects << @poly
    @objects << @level_border
  end

  def add_to_space
    @objects.each do |obj|
      obj.add_to_space @space
    end
  end

  def warp
    @player.warp vec2 320, 240
    @poly.warp vec2 0, 400
    @level_border.warp vec2 0, 0
  end
end

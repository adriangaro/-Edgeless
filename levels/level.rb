require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../utility/collision-handlers'
require_relative '../objects/platform'
require_relative '../objects/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/chip-gosu-functions'

class Level
  attr_accessor :objects, :mobs, :player, :level_border, :space

  def initialize(window)
    @window = window
    @space = CP::Space.new
    @objects = []
    @mobs = []

    declare_obj
    warp
    add_objects
    add_to_space
  end

  def declare_obj

  end

  def add_objects

  end

  def add_to_space
    @objects.each do |obj|
      obj.add_to_space @space
    end
  end

  def warp

  end
end

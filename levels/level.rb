require 'gosu'
require 'chipmunk'

require_relative '../player'
require_relative '../spike'
require_relative '../obj'
require_relative '../collision-handlers'
require_relative '../platform'
require_relative '../level_border'
require_relative '../platform_poly'
require_relative '../chip-gosu-functions'

class Level
  attr_accessor :objects, :player, :level_border, :gravity_dir, :gravity_pow, :space

  def initialize(window)
    @window = window
    @space = CP::Space.new
    @objects = []
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

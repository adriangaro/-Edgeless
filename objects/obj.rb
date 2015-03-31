require 'gosu'
require 'chipmunk'

require_relative '../utility/chip-gosu-functions'

LEVEL_BORDER = 1
PLAYER = 2
PLATFORM = 3
SPIKE = 4
MOB = 5
WEAPON = 6
WEAPON_BINDING = 7

class Obj
  attr_reader :shapes, :body
  def initialize(window, source)
    @image = Gosu::Image.new window, source
    @shapes = []
  end

  def warp(vect)
    @shapes[0].body.p = vect
  end

  def add_to_space(space)
    space.add_body @body unless @body.mass == Float::INFINITY
    @shapes.each do |shape|
      space.add_shape shape
    end
  end
end

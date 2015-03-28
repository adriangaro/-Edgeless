require 'gosu'
require 'chipmunk'

require_relative 'chip-gosu-functions'

class Obj
  attr_reader :shapes, :body
  def initialize(window, g, source)
    @image = Gosu::Image.new window, source
    @g = g
    @shapes = []
  end

  def warp(vect)
    @shapes[0].body.p = vect
  end

  def add_to_space(space)
    space.add_body @body
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_gravity(power)
    @shapes.each do |shape|
      shape.body.apply_force((vec2(0.0, 1.0) * (power)),
                             vec2(0.0, 0.0)) if @g
    end
  end
end

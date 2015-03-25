require 'gosu'
require 'chipmunk'
require_relative 'chip-gosu-functions'

class Obj
  attr_reader :shape, :body
  def initialize(window, g, source)
    @image = Gosu::Image.new window, source
    @g = g
  end

  def warp(vect)
    @shape.body.p = vect
  end

  def do_gravity(power)
    @shape.body.apply_force((CP::Vec2.new(0.0, 1.0) * (power)), CP::Vec2.new(0.0, 0.0)) if @g
  end

  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, 0, @shape.body.a.radians_to_gosu)
  end
end

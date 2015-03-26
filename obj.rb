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
      shape.body.apply_force((CP::Vec2.new(0.0, 1.0) * (power)), CP::Vec2.new(0.0, 0.0)) if @g
    end
  end
  def draw
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x, @shapes[0].body.p.y, 0, @shapes[0].body.a.radians_to_gosu, 0, 0, fx, fy)
  end
end

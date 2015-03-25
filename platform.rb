require 'gosu'
require 'chipmunk'
require_relative 'chip-gosu-functions'
require_relative 'obj'

class Platform < Obj
  def initialize(window, g, source, sizex, sizey, angle = 0)
    super window, g, source

    @sizex = sizex
    @sizey = sizey

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shape = CP::Shape::Poly.new(body, [CP::Vec2.new(0.0, 0.0), CP::Vec2.new(- @sizey, 0.0), CP::Vec2.new(- @sizey , @sizex), CP::Vec2.new(0.0, @sizex)], CP::Vec2.new(0,0))

    @shape.body.p = CP::Vec2.new(0.0, 0.0)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    @shape.e = 0.3
    @shape.body.a = (3*Math::PI/2.0) + angle / 180.0 * Math::PI
    @shape.collision_type = 0
  end

  def draw
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0/ @image.height
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, 0, @shape.body.a.radians_to_gosu, 0, 0, fx, fy)
  end
end

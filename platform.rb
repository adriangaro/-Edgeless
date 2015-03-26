require 'gosu'
require 'chipmunk'

require_relative 'chip-gosu-functions'
require_relative 'obj'

class Platform < Obj
  def initialize(window, g, sizex, sizey, angle = 0)
    super window, g, 'resources/images/platform.png'

    @sizex = sizex
    @sizey = sizey

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body,
                                   [CP::Vec2.new(0.0, 0.0),
                                    CP::Vec2.new(- @sizey, 0.0),
                                    CP::Vec2.new(- @sizey, @sizex),
                                    CP::Vec2.new(0.0, @sizex)],
                                   CP::Vec2.new(0, 0))

    @shapes.each do |shape|
      shape.body.p = CP::Vec2.new 0.0, 0.0
      shape.body.v = CP::Vec2.new 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      shape.collision_type = :platform
    end
  end
  def draw
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x,
                    @shapes[0].body.p.y,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy)
  end
end

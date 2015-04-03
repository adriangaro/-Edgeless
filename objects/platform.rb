require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class Platform < Obj
  def initialize(window, sizex, sizey, angle = 0)
    super window, 'resources/images/platform.png'

    @sizex = sizex
    @sizey = sizey

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(0.0, 0.0),
                                    vec2(- @sizey, 0.0),
                                    vec2(- @sizey, @sizex),
                                    vec2(0.0, @sizex)],
                                   vec2(0, 0))

    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      shape.collision_type = :platform
      shape.group = Group::PLATFORM
      shape.layers = Layer::PLATFORM
    end
  end
  def draw(offsetx, offsety)
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy)
  end
end

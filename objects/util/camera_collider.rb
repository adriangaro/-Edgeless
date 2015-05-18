require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative '../obj'

class CameraColliderObject < Obj
  attr_accessor
  def initialize(window)
    @window = window
    @shapes = []
    @bodies = []
    @should_draw = true
    create_bodies
    add_shapes
    set_shapes_prop
    @image = Gosu::Image.new @window, 'resources/images/test.png'
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(50, -50),
                                    vec2(-@window.height - 50, -50),
                                    vec2(-@window.height - 50, @window.width + 50),
                                    vec2(50, @window.width + 50)],
                                   vec2(0, 0))
  end

  def set_shapes_prop
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = Type::CAMERA
      shape.sensor = true
    end
  end

  def follow_camera(_offsetx, _offsety)
    shapes[0].body.p = vec2(_offsetx, _offsety)
  end

  def create_bodies
    @bodies << CP::Body.new(1, Float::INFINITY)
  end

  def draw(_offsetx, _offsety)
    fx = @window.width * 1.0 / @image.width
    fy = @window.height * 1.0 / @image.height
    x = @bodies[0].p.x - _offsetx
    y = @bodies[0].p.y - _offsety
    @image.draw_rot(x, y, 1, 0, 0, 0, fx, fy)
  end
end

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

    level_enter_animation_init
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(0, 0),
                                    vec2(-@window.height, 0),
                                    vec2(-@window.height, @window.width),
                                    vec2(0, @window.width)],
                                   vec2(0, 0))
  end

  def set_shapes_prop
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = Type::CAMERA
      shape.layers = Layer::FULL_LAYER
      shape.sensor = true
    end
  end

  def follow_camera(offsetx, offsety)
    shapes[0].body.p = vec2 offsetx, offsety
  end

  def create_bodies
    @bodies << CP::Body.new(1, 1)
  end

  def draw(); end
end

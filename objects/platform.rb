require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class Platform < Obj
  def initialize(window, sizex, sizey, angle = 0)
    super window
    @image = Assets['platform', :texture]
    @sizex = sizex
    @sizey = sizey
    @angle = angle

    @fx = @sizex * 1.0 / @image.width
    @fy = @sizey * 1.0 / @image.height
    create_bodies
    add_shapes
    set_shapes_prop
  end

  def add_shapes
    vertices = [vec2(0.0, 0.0),
                vec2(- @sizey, 0.0),
                vec2(- @sizey, @sizex),
                vec2(0.0, @sizex)]
    @shapes << CP::Shape::Poly.new(@bodies[0], vertices, vec2(0, 0))
  end

  def set_shapes_prop
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0 + @angle / 180.0 * Math::PI
      shape.collision_type = Type::PLATFORM
      shape.group = Group::PLATFORM
      shape.layers = Layer::PLATFORM
    end
  end

  def create_bodies
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
  end

  def draw
    if @should_draw
      @image.draw_rot @draw_param[0], @draw_param[1], 1, @draw_param[2], 0, 0, @fx, @fy, @draw_param[3]
    else
      level_enter_animation_init
    end
  end
end

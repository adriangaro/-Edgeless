require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class Platform < Obj
  def initialize(window, sizex, sizey, angle = 0)
    super window, 'resources/images/platform.png'

    @sizex = sizex
    @sizey = sizey
    @angle = angle

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

  def draw(offsetx, offsety)
    if(@should_draw)
      fx = @sizex * 1.0 / @image.width
      fy = @sizey * 1.0 / @image.height
      offsetsx = [offsetx]
      offsetsy = [offsety]
      offsetsy << level_enter_animation_do
      x = @bodies[0].p.x - draw_offsets(offsetsx, offsetsy).x
      y = @bodies[0].p.y - draw_offsets(offsetsx, offsetsy).y
      a = @bodies[0].a.radians_to_gosu
      @image.draw_rot(x, y, 1, a, 0, 0, fx, fy, Gosu::Color.new(@fade_in_level, 255, 255, 255))
    else
      level_enter_animation_init
    end
  end
end

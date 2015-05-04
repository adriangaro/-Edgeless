require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class TriangleMob < Mob
  def initialize(window)
    super window, 'resources/images/triangle_mob.png'
    @eyes = Gosu::Image.new(window, 'resources/images/triangle_mob_eyes.png')
    @wing = Gosu::Image.new(window, 'resources/images/triangle_mob_wing.png')
    @window = window

    @ratio = 50.0 / @image.width
    @vertices = [vec2(0.0, 25.0),
                 vec2(-43.0, 0.0),
                 vec2(-43.0, 50.0)]

    create_bodies
    add_shapes
    set_shapes_prop
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   @vertices,
                                   vec2(25, -25))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :mob
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB
  end

  def create_bodies
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def add_to_space(space)
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)

  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw(offsetx, offsety)
    x = @bodies[0].p.x - offsetx
    y = @bodies[0].p.y - offsety
    a = @bodies[0].a.radians_to_gosu
    @image.draw_rot(x, y, 1, a, 0.5, 0.5, @ratio, @ratio)

    @eyes.draw_rot(x + 1, y - 5, 1, 0, 0.5, 0.5, @ratio, @ratio)
  end
end

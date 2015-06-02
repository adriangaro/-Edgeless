require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class TriangleMob < Mob
  def initialize(window)
    super window
    @image = Assets["triangle_mob"]
    @eyes = Assets["triangle_mob_eyes"]
    @wing = Assets["triangle_mob_wing"]
    @window = window

    @ratio = 50.0 / @image.width
    @wing_ratio = 328 / 90.0
    @vertices = [vec2(0.0, 25.0),
                 vec2(-43.0, 0.0),
                 vec2(-43.0, 50.0)]
    @vertices2 = [vec2(0.0, 25.0 / @wing_ratio),
                  vec2(-43.0 / @wing_ratio, 0.0),
                  vec2(-43.0 / @wing_ratio, 50.0 / @wing_ratio)]
    create_bodies
    add_shapes
    set_shapes_prop
    set_stats(100, 0)
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   @vertices,
                                   vec2(25, -25))
    @shapes << CP::Shape::Poly.new(@bodies[1],
                                   @vertices2,
                                   vec2(25 / @wing_ratio, -25 / @wing_ratio))
    @shapes << CP::Shape::Poly.new(@bodies[2],
                                   @vertices2,
                                   vec2(25 / @wing_ratio, -25 / @wing_ratio))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = Type::MOB
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0.3
    @shapes[1].body.a = 3 * Math::PI / 2.0
    @shapes[1].collision_type = Type::MOB
    @shapes[1].group = Group::MOB
    @shapes[1].layers = Layer::MOB

    @shapes[2].body.p = vec2 0.0, 0.0
    @shapes[2].body.v = vec2 0.0, 0.0
    @shapes[2].e = 0.3
    @shapes[2].body.a = 3 * Math::PI / 2.0
    @shapes[2].collision_type = Type::MOB
    @shapes[2].group = Group::MOB
    @shapes[2].layers = Layer::MOB
  end

  def create_bodies
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect + vec2(-15, -10)
    @shapes[2].body.p = vect + vec2(15, -10)
    @init_pos = vect
  end

  def add_to_space(space)
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    set_animation(EXTRA, get_animation("trianglemob", "wingsanim").dup, true)
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw()
    if(@should_draw)
      @image.draw_rot @draw_param[0], @draw_param[1], 1, @draw_param[2], 0.5, 0.5, @ratio, @ratio, @draw_param[3]

      @eyes.draw_rot @draw_param[0] + 1, @draw_param[1] - 5, 1, 0, 0.5, 0.5, @ratio, @ratio, @draw_param[3]

      @wing.draw_rot @draw_param[0] - 15, @draw_param[1] - 10, 1, @draw_param[2], 1, 1, @ratio, @ratio, @draw_param[3]

      @wing.draw_rot @draw_param[0] + 15, @draw_param[1] - 10, 1, @draw_param[2], 1, 1, -@ratio, @ratio, @draw_param[3]
      @health_bar.draw @draw_param[0] - 25, @draw_param[1] + 30, 2
    else
      level_enter_animation_init
    end
  end
end

require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  def initialize(window, finish)
    super window, 'resources/images/square_mob.png'
    @window = window
    @eyes = Gosu::Image.new(window, 'resources/images/square_mob_eyes.png')
    @finish_pos = finish
    @where = "start"
    @last = vec2(0, 0)
    @ratio = 50.0 / @image.width
    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

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
    @bodies << CP::Body.new(10.0, 1000)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def add_to_space(space)
    space.add_body @bodies[0]
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    @where = "finish" if (bodies[0].p.x > @finish_pos.x && @finish_pos.x > @init_pos.x) || (bodies[0].p.x < @finish_pos.x && @finish_pos.x < @init_pos.x)
    @where = "start" if  (@finish_pos.x > @init_pos.x && @init_pos.x > bodies[0].p.x) || (@finish_pos.x < @init_pos.x && @init_pos.x < bodies[0].p.x)
    if @where == "start"
      if @finish_pos.x > @init_pos.x
        set_animation(MOVEMENT, Anims::SQUARE_MOB["right"].dup, true)
      else
        set_animation(MOVEMENT, Anims::SQUARE_MOB["left"].dup, true)
      end
    else
      if @finish_pos.x > @init_pos.x
        set_animation(MOVEMENT, Anims::SQUARE_MOB["left"].dup, true)
      else
        set_animation(MOVEMENT, Anims::SQUARE_MOB["right"].dup, true)
      end
    end
    @dir = (@bodies[0].p - @last).x / (@bodies[0].p - @last).x.abs
    @last = vec2(@bodies[0].p.x, @bodies[0].p.y)
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw(offsetx, offsety)
    x = @bodies[0].p.x - offsetx
    y = @bodies[0].p.y - offsety
    a = @bodies[0].a.radians_to_gosu
    @image.draw_rot(x, y, 1, a, 0.5, 0.5, @ratio, @ratio)

    @eyes.draw_rot(x + 5 * @dir, y - 5, 1, 0, 0.5, 0.5, @ratio * @dir, @ratio)
  end

  ATTACKED_HOOKS << lambda do |victim, attacker|
    victim.bodies[0].apply_impulse vec2(0, -9000), vec2(0, 0)
  end
end

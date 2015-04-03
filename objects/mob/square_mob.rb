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

    @finish_pos = finish
    @change = true

    @body = CP::Body.new 10.0, 1000

    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    @shapes << CP::Shape::Poly.new(@body,
                                   @vertices,
                                   vec2(0, 0))

    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :mob
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB

  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def add_to_space(space)
    space.add_body @body
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    @dir = ((@finish_pos - @init_pos).x / 0).infinite?

    @change = false if @dir * @shapes[0].body.p.x > @dir * @finish_pos.x

    @change = true if @dir * @shapes[0].body.p.x < @dir * @init_pos.x

    if @change
      @shapes[0].body.apply_force vec2(1, 1) * @dir * 300, vec2(-25, -25)
      @shapes[0].body.ang_vel = @dir * Math::PI / 4
    else
      @shapes[0].body.apply_force vec2(-1, 1) * @dir * 300, vec2(25, -25)
      @shapes[0].body.ang_vel = - @dir * Math::PI / 4
    end
  end

  def draw(offsetx, offsety)
    fx = 50 * 1.0 / @image.width
    fy = 50 * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy
                    )
  end
end

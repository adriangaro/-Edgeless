require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/chip-gosu-functions'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  def initialize(window, finish)
    super window, 'resources/images/square_mob.png'
    @window = window
    @finish_pos = finish
    @change = true
    @sword = Gosu::Image.new window, 'resources/images/sword.png'
    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    @body = CP::Body.new 10.0, 1000
    @shapes << CP::Shape::Poly.new(@body,
                                   @vertices,
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@body,
                                   [vec2(-25, -40),
                                    vec2(-25, 25),
                                    vec2(25, 25),
                                    vec2(25, -40)],
                                   vec2(0, 0))
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :mob

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0.3
    @shapes[1].body.a = 3 * Math::PI / 2.0
    @shapes[1].collision_type = :sword
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def do_behaviour
    @dir = ((@finish_pos - @init_pos).x / 0).infinite?

    if @dir * @shapes[0].body.p.x > @dir * @finish_pos.x
      @change = false
    end

    if @dir * @shapes[0].body.p.x < @dir * @init_pos.x
      @change = true
    end

    if @change
      @shapes[0].body.apply_force vec2(1,1) * @dir * 300, vec2(-25,-25)
      @shapes[0].body.ang_vel = @dir * Math::PI / 4
    else
      @shapes[0].body.apply_force vec2(-1,1) * @dir * 300, vec2(25,-25)
      @shapes[0].body.ang_vel = - @dir * Math::PI / 4
    end
  end

  def draw(offsetx, offsety)
    fx = 50 * 1.0 / @image.width
    fy = 50 * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy
                    )
    fx = 50 * 1.0 / @sword.width
    fy = 65 * 1.0 / @sword.height
    @sword.draw_rot(@shapes[1].body.p.x - offsetx - 25,
                    @shapes[1].body.p.y - offsety - 40,
                    0,
                    Math::PI / 4 * 3,
                    0,
                    0,
                    fx,
                    fy
                    )
  end
end

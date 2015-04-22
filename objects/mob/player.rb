require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative 'mob'

SUBSTEPS = 6
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
class Player < Mob
  attr_accessor :jump
  def initialize(window, diameter)
    super window, 'resources/images/player.png'
    @sword = Gosu::Image.new(window,
                             Magick::Image.read('resources/images/sword.png')[0].flip!)

    @diameter = diameter

    create_bodies
    add_shapes
    set_shapes_prop

    @dir = 1

    @attacking = false
    @target_angle = Math::PI / 2.0 + Math::PI / 18
  end

  def add_shapes
    @shapes << CP::Shape::Circle.new(@bodies[0], @diameter / 2, vec2(0, 0))

    @shapes << CP::Shape::Poly.new(@bodies[1],
                                   [vec2(0, 0),
                                    vec2(65, 0),
                                    vec2(65, -20),
                                    vec2(0, -20)],
                                   vec2(0, 10))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0
    @shapes[0].body.a = Math::PI / 2.0
    @shapes[0].collision_type = :ball
    @shapes[0].group = Group::PLAYER
    @shapes[0].layers = Layer::PLAYER

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0
    @shapes[1].body.a = 3 * Math::PI / 2.0 + Math::PI / 18
    @shapes[1].collision_type = :sword
    @shapes[1].group = Group::WEAPON
    @shapes[1].layers = Layer::WEAPON
  end

  def create_bodies
    @bodies << CP::Body.new(30.0, Float::INFINITY)
    @bodies << CP::Body.new(10.0, Float::INFINITY)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect + vec2(@dir * (@diameter / 2 + 5), 15)
    @init_pos = vect
  end

  def add_to_space(space)
    space.add_body @bodies[0]
    space.add_shape @shapes[0]
    space.add_shape @shapes[1]
  end

  def turn_left
    @shapes[0].body.t -= 600.0 / SUBSTEPS
    @shapes[1].body.a = 3 * Math::PI / 2.0 - Math::PI / 18 if @shapes[1].body.a > 3 * Math::PI / 2.0 && !@attacking
    @dir = -1
  end

  def turn_right
    @shapes[0].body.t += 600.0 / SUBSTEPS
    @shapes[1].body.a = 3 * Math::PI / 2.0 + Math::PI / 18 if @shapes[1].body.a < 3 * Math::PI / 2.0 && !@attacking
    @dir = 1
  end

  def accelerate_left
    @shapes[0].body.apply_force((vec2(-1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
    @shapes[1].body.p = @shapes[0].body.p + vec2(@dir * (@diameter / 2 + 5), 15) if @shapes[1].body.a > 3 * Math::PI / 2.0 && !@attacking
  end

  def accelerate_right
    @shapes[0].body.apply_force((vec2(1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
    @shapes[1].body.p = @shapes[0].body.p + vec2(@dir * (@diameter / 2 + 5), 15) if @shapes[1].body.a < 3 * Math::PI / 2.0 && !@attacking
  end

  def attack
    @dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    @dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0

    @target_angle = @shapes[1].body.a + Math::PI / 2.0 * @dir unless @attacking
    @attacking = true
  end

  def jump
    @shapes[0].body.apply_force((vec2(0.0, -1.0) * 90_000.0),
                                vec2(0.0, 0.0)) if @jump
  end

  def do_behaviour(space)
    Anims::PLAYER[0].do_animation(@bodies)
    @dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    @dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0
    @shapes[1].body.p = @shapes[0].body.p + vec2(@dir * (@diameter / 2 + 5), 15)
    puts @attacking
    space.reindex_static
    return unless @attacking
    sword_go_up
    sword_go_down
    @target_angle = 3 * Math::PI / 2.0 + Math::PI / 18.0 * @dir if @target_angle * @dir <= @shapes[1].body.a * @dir
    @attacking = false if (3 * Math::PI / 2.0 + Math::PI / 18.0 * @dir).round(4) == @shapes[1].body.a.round(4)
  end

  def sword_go_down
    @shapes[1].body.a += 2 * Math::PI / 180.0 * @dir if ((@shapes[1].body.a > 3 *  Math::PI / 2.0 - Math::PI / 4 ) ||
                                                         (@shapes[1].body.a < 3 *  Math::PI / 2.0 + Math::PI / 4 )) &&
                                                        (3 * Math::PI / 2.0 + 1 * Math::PI / 18 != @target_angle &&
                                                         3 * Math::PI / 2.0 - 1 * Math::PI / 18 != @target_angle) &&
                                                        @attacking
  end

  def sword_go_up
    @shapes[1].body.a -= 2 * Math::PI / 180.0 * @dir if (@shapes[1].body.a - @target_angle > 0 && @dir == 1) ||
                                                        (@shapes[1].body.a - @target_angle < 0 && @dir == -1) &&
                                                        @attacking
  end

  def respawn
    @shapes[0].body.p = @init_pos
    @shapes[1].body.p = @init_pos + vec2(@dir * (@diameter / 2 + 5), -65)
  end

  def draw(offsetx, offsety)
    f = @diameter * 1.0 / @image.width
    dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0
    x = @shapes[0].body.p.x - offsetx
    y = @shapes[0].body.p.y - offsety
    @image.draw_rot(x, y, 1, 0, 0.5, 0.5, f * dir, f)

    fx = 20 * 1.0 / @sword.width
    fy = 65 * 1.0 / @sword.height
    x = @shapes[1].body.p.x - offsetx
    y = @shapes[1].body.p.y - offsety
    a = (@shapes[1].body.a + Math::PI).radians_to_gosu
    @sword.draw_rot(x, y, 1, a, 0.5, 0, fx, fy)
  end
end

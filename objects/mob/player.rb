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
                             Magick::Image.read('resources/images/sword.png')[0].flip!.flop!)

    @diameter = diameter

    @body = CP::Body.new 20.0, 150.0
    @body_weapon = CP::Body.new 10.0, Float::INFINITY

    @joint_body_sword = CP::Constraint::PinJoint.new @body,
                                                     @body_weapon,
                                                     vec2(0, 0),
                                                     vec2(0, 0)
    @joint_body_sword.dist = 0
    @joint_body_sword.error_bias = 0

    @shapes << CP::Shape::Circle.new(body, diameter / 2, vec2(0, 0))

    @shapes << CP::Shape::Poly.new(@body_weapon,
                                   [vec2(0, -20),
                                    vec2(0, 0),
                                    vec2(65, 0),
                                    vec2(65, -20)],
                                   vec2(10, 10))

    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :ball
    @shapes[0].group = Group::PLAYER
    @shapes[0].layers = Layer::PLAYER

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0
    @shapes[1].body.a = 3 * Math::PI / 2.0 - Math::PI / 18
    @shapes[1].collision_type = :sword
    @shapes[1].group = Group::WEAPON
    @shapes[1].layers = Layer::WEAPON

    @attacking = false
    @target_angle = 3 * Math::PI / 2.0 - Math::PI / 18
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect
  end

  def add_to_space(space)
    space.add_body @body
    space.add_body @body_weapon

    @joint_body_sword.add_to_space space

    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def turn_left
    @shapes[0].body.t -= 600.0 / SUBSTEPS
    @shapes[1].body.a = 3 * Math::PI / 2.0 - Math::PI / 18 if @shapes[1].body.a > 3 * Math::PI / 2.0 && !@attacking
  end

  def turn_right
    @shapes[0].body.t += 600.0 / SUBSTEPS
    @shapes[1].body.a = 3 * Math::PI / 2.0 + Math::PI / 18 if @shapes[1].body.a < 3 * Math::PI / 2.0 && !@attacking
  end

  def accelerate_left
    @shapes[0].body.apply_force((vec2(-1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
  end

  def accelerate_right
    @shapes[0].body.apply_force((vec2(1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
  end

  def attack
    dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0

    @target_angle = @shapes[1].body.a + Math::PI / 2.0 * dir unless @attacking
    @attacking = true
  end

  def jump
    @shapes[0].body.apply_force((vec2(0.0, -1.0) * 90_000.0),
                                vec2(0.0, 0.0)) if @jump
  end

  def do_behaviour(_space)
    dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0
    if @attacking
      @shapes[1].body.a += Math::PI / 180.0 * dir if ((@shapes[1].body.a > 3 * Math::PI / 2.0 - 3 * Math::PI / 4 ) ||
                                                      (@shapes[1].body.a < 3 * Math::PI / 2.0 + 3 * Math::PI / 4 )) &&
                                                     (3 * Math::PI / 2.0 + 1 * Math::PI / 18 != @target_angle &&
                                                      3 * Math::PI / 2.0 - 1 * Math::PI / 18 != @target_angle) &&
                                                     @attacking

      @shapes[1].body.a -= Math::PI / 180.0 * dir if (@shapes[1].body.a - @target_angle > 0 && dir == 1) ||
                                                     (@shapes[1].body.a - @target_angle < 0 && dir == -1) &&
                                                     @attacking

      @target_angle = 3 * Math::PI / 2.0 + Math::PI / 18.0 * dir if @target_angle.round(4) - @shapes[1].body.a.round(4) == 0.0
      @attacking = false if (3 * Math::PI / 2.0 + Math::PI / 18.0 * dir).round(4) - @shapes[1].body.a.round(4) == 0.0
    end
  end

  def draw(offsetx, offsety)
    f = @diameter * 1.0 / @image.width
    dir = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    dir = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    0,
                    0.5,
                    0.5,
                    f * dir,
                    f)
    fx = 20 * 1.0 / @sword.width
    fy = 65 * 1.0 / @sword.height

    fa = -1 if 3 * Math::PI / 2.0 - @shapes[1].body.a > 0
    fa = 1 if 3 * Math::PI / 2.0 - @shapes[1].body.a < 0

    @sword.draw_rot(@shapes[1].body.p.x - offsetx + 10.0 * Math::sqrt(2) / 2,
                    @shapes[1].body.p.y - offsety + 10.0 * Math::sqrt(2) / 2 * fa,
                    1,
                    @shapes[1].body.a.radians_to_gosu,
                    0,
                    0,
                    -fx,
                    -fy
                    )
  end
end

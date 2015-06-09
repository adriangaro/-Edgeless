require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative '../obj'

class Projectile < Mob
  attr_accessor :angle, :animation, :parent

  def initialize(window, animation, angle, image, radius, x, y, parent)
    super window
    @bodies << CP::Body.new(10, 1000)
    @angle = angle
    @image = image
    @shapes << CP::Shape::Circle.new(@bodies[0], radius)
    @parent = parent
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = @angle + 3 * Math::PI / 2
      shape.collision_type = Type::PROJECTILE
      shape.group = Group::PROJECTILE
      shape.layers = Layer::PROJECTILE
    end

    @animation = animation
    @f = radius * 2.0 / image.width
    TASKS << lambda do
      mob = self
      mob.warp vec2(x, y)
      $level.mobs << mob
      mob.add_to_space $level.space
    end
    @miliseconds_level = 0
  end

  def do_gravity; end

  def do_behaviour(_space)
    set_animation EXTRA, @animation.dup, true, @angle
  end

  def draw
    @image.draw_rot @draw_param[0], @draw_param[1], 1, @draw_param[2], 0.5, 0.5, @f, @f
  end
end

Projectile.add_attack_hook BaseHooks::PROJECTILE_HIT

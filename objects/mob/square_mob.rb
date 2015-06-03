require 'gosu'
require 'chipmunk'
require 'RMagick'
require 'ruby-prof'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  attr_accessor :init_pos, :finish_pos
  def initialize(window)
    super window
    @window = window
    @image = Assets['square_mob']
    @eyes = Assets['square_mob_eyes']
    @where = 'start'
    @last = vec2 0, 0
    @ratio = 50.0 / @image.width
    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    create_bodies
    add_shapes
    set_shapes_prop
    set_stats 50, 0
    @fsm.push_state -> { idle }
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   @vertices,
                                   vec2(25, -25))
    @shapes << CP::Shape::Circle.new(bodies[0], 500, vec2(0, 0))
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
    @shapes[1].collision_type = Type::SENSOR
    @shapes[1].group = Group::SENSOR
    @shapes[1].layers = Layer::SENSOR
    @shapes[1].sensor = true
  end

  def create_bodies
    @bodies << CP::Body.new(10.0, 1000)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
    @finish_pos = vect + vec2(200, 0)
    @dir = 1
  end

  def add_to_space(space)
    space.add_body @bodies[0]
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    @dir = (@bodies[0].p - @last).x / (@bodies[0].p - @last).x.abs
    @last = vec2 @bodies[0].p.x, @bodies[0].p.y

    @fsm.update
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw
    if @should_draw
      @image.draw_rot @draw_param[0], @draw_param[1], 1, @draw_param[2], 0.5, 0.5, @ratio, @ratio, @draw_param[3]
      @eyes.draw_rot @draw_param[0] + 5 * @dir, @draw_param[1] - 5, 1, 0, 0.5, 0.5, @ratio * @dir, @ratio, @draw_param[3]
      @health_bar.draw @draw_param[0] - 25, @draw_param[1] + 30, 2
    else
      level_enter_animation_init
    end
  end

  ATTACKED_HOOKS << BaseHooks::KNOCKBACK

  ##############################################
  #AI                                          #
  ##############################################

  def idle
    @fsm.push_state -> { chase_player } if @agro
  end

  def chase_player
    if $level.player.bodies[0].p.x - @bodies[0].p.x > 0
      set_animation MOVEMENT, get_animation('squaremob', 'right').dup, true
    else
      set_animation MOVEMENT, get_animation('squaremob', 'left').dup, true
    end

    @fsm.pop_state if $level.player.curent_lives <= 0 || !@agro
  end
end

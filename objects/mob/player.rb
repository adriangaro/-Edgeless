require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative 'mob'

SUBSTEPS = 6
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
class Player < Mob
  attr_accessor :jump, :miliseconds_level
  def initialize(window)
    super window
    @image = Assets['player']
    @sword = Assets['sword']

    @diameter = 50

    @ratio = @diameter * 1.0 / @image.width
    create_bodies
    add_shapes
    set_shapes_prop
    @hide_time = 0
    @weapon_hidden = false
    @alpha = 255

    @init_pos = []

    @dir = 1

    @attacking = false
    @target_angle = Math::PI / 2.0 + Math::PI / 18
    set_stats 100, 50

    @fsm.push_state -> { idle }
  end

  def add_shapes
    @shapes << CP::Shape::Circle.new(@bodies[0], @diameter / 2, vec2(0, 0))

    @shapes << CP::Shape::Poly.new(@bodies[1],
                                   [vec2(0, 0),
                                    vec2(@sword.height * @ratio, 0),
                                    vec2(@sword.height * @ratio, -@sword.width * @ratio),
                                    vec2(0, -@sword.width * @ratio)],
                                   vec2(0, @sword.width * @ratio / 2))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0
    @shapes[0].body.a = Math::PI / 2.0
    @shapes[0].collision_type = Type::PLAYER
    @shapes[0].group = Group::PLAYER
    @shapes[0].layers = Layer::PLAYER

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0
    @shapes[1].body.a = 3 * Math::PI / 2.0 + Math::PI / 18
    @shapes[1].collision_type = Type::WEAPON
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
    @last = vect
    @init_pos[0] = vect
    @init_pos[1] = vect + vec2(@dir * (@diameter / 2 + 5), 15)
  end

  def add_to_space(space)
    space.add_body @bodies[0]
    space.add_shape @shapes[0]
    space.add_shape @shapes[1]
  end

  def turn_left
    @shapes[0].body.t -= 600.0 / SUBSTEPS
    @dir = -1
  end

  def turn_right
    @shapes[0].body.t += 600.0 / SUBSTEPS
    @dir = 1
  end

  def accelerate_left
    stop_idle_anim
    set_animation MOVEMENT, get_animation('player', 'left').dup, true

  end

  def accelerate_right
    stop_idle_anim
    set_animation MOVEMENT, get_animation('player', 'right').dup, true
  end

  def attack
    stop_idle_anim
    set_animation BEHAVIOUR, get_animation('player', 'attackright').dup if @dir == 1 && !@attacking
    set_animation BEHAVIOUR, get_animation('player', 'attackleft').dup if @dir == -1 && !@attacking
    @attacking = true
  end

  def jump
    stop_idle_anim
    over_write_animation MOVEMENT, get_animation('player', 'jump').dup if @jump
  end

  def do_behaviour(space)
    @bodies[1].p += @bodies[0].p - @last
    @last = vec2 @bodies[0].p.x, @bodies[0].p.y
    @attacking = false if @cur_anim[1].nil?
    if @weapon_hidden
      @bodies[1].p = @bodies[0].p + vec2(@dir * (@diameter / 2 + 5), 15)
      @bodies[1].a = 3 * Math::PI / 2 + @dir * Math::PI / 18
    end

    @fsm.update

    do_animations
  end

  def stop_idle_anim
    return if @cur_anim[2].nil?
    @cur_anim[2] = nil
    @bodies[1].p = @bodies[0].p + vec2(@dir * (@diameter / 2 + 5), 15)
    @bodies[1].a = 3 * Math::PI / 2 + @dir * Math::PI / 18
  end

  def respawn
    @shapes[0].body.p = @init_pos[0]
  end

  def draw
    @image.draw_rot @draw_param[0], @draw_param[1], 1, 0, 0.5, 0.5, @ratio * @dir, @ratio, @draw_param[3]

    x = @bodies[1].p.x + draw_param[0] - @bodies[0].p.x
    y = @bodies[1].p.y + draw_param[1] - @bodies[0].p.y
    a = (@shapes[1].body.a + Math::PI).radians_to_gosu
    @sword.draw_rot x, y, 2, a + 180, 0.5, 1, @ratio, @ratio, Gosu::Color.new(@alpha * @fade_in_level / 255.0, 255, 255, 255)
  end

  ATTACK_HOOKS << BaseHooks::DO_DAMAGE

  ##############################################
  #AI                                          #
  ##############################################

  def idle
    if @cur_anim[0].nil? && @cur_anim[1].nil?
      rnd = Random.new
      x = rnd.rand(3000)
      if x == 1
        set_animation EXTRA, get_animation('player', 'leftidle1').dup if @dir == -1
        set_animation EXTRA, get_animation('player', 'rightidle1').dup if @dir == 1
      end
    end

    if (@dir == 1 && @bodies[1].a < 3 * Math::PI / 2 && !@weapon_hidden) ||
       (@dir == -1 && @bodies[1].a > 3 * Math::PI / 2 && !@weapon_hidden)
      @fsm.push_state -> { change_dir }
      return
    end

    if @cur_anim[1].nil? && @cur_anim[2].nil?
      @fsm.push_state -> { hide_weapon }
      return
    else
      @fsm.push_state -> { show_weapon }
      return
    end
  end

  def change_dir
    set_animation BEHAVIOUR, get_animation('player', 'changedirectionright').dup if @dir == 1 &&
                                                                                    @bodies[1].a < 3 * Math::PI / 2 &&
                                                                                    !@weapon_hidden
    set_animation BEHAVIOUR, get_animation('player', 'changedirectionleft').dup if @dir == -1 &&
                                                                                    @bodies[1].a > 3 * Math::PI / 2 &&
                                                                                    !@weapon_hidden
    @fsm.pop_state
  end

  def hide_weapon
    @hide_time += 1

    if @hide_time > 70
      @weapon_hidden = true
      @shapes[1].layers = Layer::NULL_LAYER
      @alpha -= 6 if @alpha > 0
    end

    @fsm.pop_state

    if (@dir == 1 && @bodies[1].a < 3 * Math::PI / 2 && !@weapon_hidden) ||
       (@dir == -1 && @bodies[1].a > 3 * Math::PI / 2 && !@weapon_hidden)
      @fsm.push_state -> { change_dir }
      return
    end
  end

  def show_weapon
    @hide_time = 0

    @weapon_hidden = false
    @shapes[1].layers = Layer::WEAPON
    @alpha += 30 if @alpha < 255

    @fsm.pop_state

    if (@dir == 1 && @bodies[1].a < 3 * Math::PI / 2 && !@weapon_hidden) ||
       (@dir == -1 && @bodies[1].a > 3 * Math::PI / 2 && !@weapon_hidden)
      @fsm.push_state -> { change_dir }
      return
    end
  end
end

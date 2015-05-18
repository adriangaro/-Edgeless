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
    super window, 'resources/images/player.png'
    @sword = Gosu::Image.new(window,
                             Magick::Image.read('resources/images/sword.png')[0].flip!)

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
    set_animation(MOVEMENT, get_animation("player", "left").dup, true)

  end

  def accelerate_right
    stop_idle_anim
    set_animation(MOVEMENT, get_animation("player", "right").dup, true)
  end

  def attack
    stop_idle_anim
    set_animation(BEHAVIOUR, get_animation("player", "attackright").dup) if @dir == 1 && !@attacking
    set_animation(BEHAVIOUR, get_animation("player", "attackleft").dup) if @dir == -1 && !@attacking
    @attacking = true
  end

  def jump
    stop_idle_anim
    over_write_animation(MOVEMENT, get_animation("player", "jump").dup) if @jump
  end

  def do_behaviour(space)
    if @cur_anim[0].nil? && @cur_anim[1].nil?
      rnd = Random.new
      x = rnd.rand(3000)
      if x == 1
        set_animation(EXTRA, get_animation("player", "leftidle1").dup) if @dir == -1
        set_animation(EXTRA, get_animation("player", "rightidle1").dup) if @dir == 1
      end
    end

    set_animation(BEHAVIOUR, get_animation("player", "changedirectionright").dup) if @dir == 1 &&
                                                                           @bodies[1].a < 3 * Math::PI / 2 &&
                                                                           !@weapon_hidden
    set_animation(BEHAVIOUR, get_animation("player", "changedirectionleft").dup) if @dir == -1 &&
                                                                          @bodies[1].a > 3 * Math::PI / 2 &&
                                                                          !@weapon_hidden

    @bodies[1].p += @bodies[0].p - @last
    @last = vec2(@bodies[0].p.x,@bodies[0].p.y)
    @attacking = false if @cur_anim[1].nil?

    if @weapon_hidden
      @bodies[1].p = @bodies[0].p + vec2(@dir * (@diameter / 2 + 5), 15)
      @bodies[1].a = 3 * Math::PI / 2 + @dir * Math::PI / 18
    end

    if @cur_anim[1].nil? && @cur_anim[2].nil?
      @hide_time += 1
    else
      @hide_time = 0
    end

    if @hide_time > 400
      hide_sword
    else
      show_sword
    end
    do_animations
  end

  def stop_idle_anim
    unless @cur_anim[2].nil?
      @cur_anim[2] = nil
      @bodies[1].p = @bodies[0].p + vec2(@dir * (@diameter / 2 + 5), 15)
      @bodies[1].a = 3 * Math::PI / 2 + @dir * Math::PI / 18
    end
  end

  def hide_sword
    @weapon_hidden = true
    @shapes[1].layers = Layer::NULL_LAYER
    @alpha -= 1 if @alpha > 0
  end

  def show_sword
    @weapon_hidden = false
    @shapes[1].layers = Layer::WEAPON
    @alpha += 5 if @alpha < 255
  end

  def respawn
    @shapes[0].body.p = @init_pos[0]
  end

  def draw(offsetx, offsety)
    offsetsx = [offsetx]
    offsetsy = [offsety]
    offsetsy << level_enter_animation_do
    x = @bodies[0].p.x - draw_offsets(offsetsx, offsetsy).x
    y = @bodies[0].p.y - draw_offsets(offsetsx, offsetsy).y
    @image.draw_rot(x, y, 1, 0, 0.5, 0.5, @ratio * @dir, @ratio, Gosu::Color.new(@fade_in_level, 255, 255, 255))

    x = @bodies[1].p.x - draw_offsets(offsetsx, offsetsy).x
    y = @bodies[1].p.y - draw_offsets(offsetsx, offsetsy).y
    a = (@shapes[1].body.a + Math::PI).radians_to_gosu
    @sword.draw_rot(x, y, 2, a, 0.5, 0, @ratio, @ratio, Gosu::Color.new(@alpha * @fade_in_level / 255.0, 255, 255, 255))
  end

  ATTACK_HOOKS << lambda do |attacker, victim|
    puts "auch"
  end
end

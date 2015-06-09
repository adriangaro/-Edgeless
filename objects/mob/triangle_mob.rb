require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'projectile'
require_relative 'mob'

class TriangleMob < Mob
  def initialize(window)
    super window
    @image = Assets['triangle_mob']
    @eyes = Assets['triangle_mob_eyes']
    @wing = Assets['triangle_mob_wing']
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
    set_stats 500, 100
    @fsm.push_state -> { idle }
    @last_time = 0
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

  def do_gravity; end

  def create_bodies
    @bodies << CP::Body.new(30, Float::INFINITY)
    @bodies << CP::Body.new(10, Float::INFINITY)
    @bodies << CP::Body.new(10, Float::INFINITY)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect + vec2(-15, -10)
    @shapes[2].body.p = vect + vec2(15, -10)
  end

  def do_behaviour(space)
    @knockback = false
    dist = @bodies[0].p.distsq($level.player.bodies[0].p)
    @agro = dist < 1000000
    @bodies[1].p = @bodies[0].p + vec2(-15, -10)
    @bodies[2].p = @bodies[0].p + vec2(15, -10)
    set_animation EXTRA, get_animation('trianglemob', 'wingsanim').dup, true

    @fsm.update
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def get_draw_param(offsetx, offsety)
    offsetsx = [offsetx]
    offsetsy = [offsety]
    offsetsy << level_enter_animation_do
    @draw_param = [@bodies[0].p.x - draw_offsets(offsetsx, offsetsy).x,
                   @bodies[0].p.y - draw_offsets(offsetsx, offsetsy).y,
                   @bodies[0].a.radians_to_gosu,
                   @bodies[1].a.radians_to_gosu,
                   @bodies[2].a.radians_to_gosu,
                   Gosu::Color.new(@fade_in_level, 255, 255, 255)]
  end

  def draw()
    if @should_draw
      @image.draw_rot @draw_param[0], @draw_param[1], 1, @draw_param[2], 0.5, 0.5, @ratio, @ratio, @draw_param[5]

      @eyes.draw_rot @draw_param[0] + 1, @draw_param[1] - 5, 1, 0, 0.5, 0.5, @ratio, @ratio, @draw_param[5]

      @wing.draw_rot @draw_param[0] - 15, @draw_param[1] - 10, 1, @draw_param[3], 1, 1, @ratio, @ratio, @draw_param[5]

      @wing.draw_rot @draw_param[0] + 15, @draw_param[1] - 10, 1, @draw_param[4], 1, 1, -@ratio, @ratio, @draw_param[5]
      @health_bar.draw @draw_param[0] - 25, @draw_param[1] + 30, 2
    else
      level_enter_animation_init
    end
  end

  ##############################################
  #AI                                          #
  ##############################################

  def idle
    if @agro
      @fsm.push_state -> { chase_player }
      return
    end
    random = Random.new
    if random.rand(20) == 1
      distx = random.rand(600) - 300
      disty = random.rand(600) - 300
      @destination = @bodies[0].p + vec2(distx, disty)
      @fsm.push_state -> { wonder }
      return
    end
  end

  def chase_player
    set_animation MOVEMENT, get_animation('trianglemob', 'move').dup, true, ($level.player.bodies[0].p - @bodies[0].p).to_angle
    @dir = 1

    if @bodies[0].p.distsq($level.player.bodies[0].p) < 90000
      @fsm.push_state -> { attack_player }
      return
    end

    if $level.player.curent_lives <= 0 || !@agro
      @fsm.pop_state
      return
    end
  end

  def attack_player
    set_animation MOVEMENT, get_animation('trianglemob', 'move').dup, true, 3 * Math::PI / 2 if ($level.player.bodies[0].p.y - @bodies[0].p.y) < 200
    @last_time += 1
    Projectile.new(@window, get_animation('projectile', 'line').dup, ($level.player.bodies[0].p - @bodies[0].p).to_angle, Assets['triangle_mob_projectile'], 10, @bodies[0].p.x, @bodies[0].p.y, self) if @last_time % 90 == 0
    if @bodies[0].p.distsq($level.player.bodies[0].p) > 90000
      @fsm.pop_state
      @last_time = 0
      return
    end
  end

  def wonder
    over_write_animation MOVEMENT, get_animation('trianglemob', 'move').dup, true, (@destination - @bodies[0].p).to_angle

    @fsm.pop_state if @destination.distsq(@bodies[0].p) < 400 || @agro ||
                      @destination.x > 0 || @destination.y > 0 ||
                      @destination.x < $level.width || @destination.y < $level.height
  end
end

TriangleMob.add_attack_hook BaseHooks::DO_DAMAGE

TriangleMob.add_attacked_hook BaseHooks::KNOCKBACK

require 'gosu'
require 'chipmunk'
require 'texplay'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative '../../ai/fsm'


module BaseHooks
  DO_DAMAGE = lambda do |attacker, victim|
    victim.curent_lives -= attacker.curent_dmg
    victim.draw_health
    TASKS << lambda do
      victim.destroy
      victim.call_trigger :dead
      victim = nil
    end if victim.curent_lives <= 0
  end

  PROJECTILE_HIT = lambda do |attacker, victim|
    attack_hook(attacker.parent.shapes[0], victim.shapes[0], $level)
  end

  KNOCKBACK = lambda do |victim, attacker|
    unless victim.knockback
      victim.bodies[0].v = vec2(50, 0).rotate(-(attacker.bodies[0].p - victim.bodies[0].p).to_angle.radians_to_vec2) * $delta_factor

      victim.knockback = true
    end
  end
end

class Mob < Obj
  include ClassLevelInheritableAttributes
  inheritable_attributes :attack_hooks, :attacked_hooks

  MOVEMENT = 0
  BEHAVIOUR = 1
  EXTRA = 2

  @attack_hooks = []
  @attacked_hooks = []

  class << self
    def add_attack_hook(hook)
      aux = @attack_hooks.dup
      @attack_hooks = (aux << hook)
    end

    def add_attacked_hook(hook)
      aux = @attacked_hooks.dup
      @attacked_hooks = (aux << hook)
    end
  end

  attr_accessor :cur_anim, :lives, :dmg, :curent_lives, :curent_dmg, :dir, :health_bar, :fsm, :knockback, :g, :active

  def initialize(window)
    super window
    @cur_anim = []
    @dmg = -1
    @lives = -1
    @curent_lives = -1
    @curent_dmg = -1
    @dir = 1
    draw_health
    @fsm = StackFSM.new
    @knockback = false
    @g = vec2 0, 500
    @active = true
  end

  def do_gravity
    @bodies.each { |body| body.apply_force @g, vec2(0, 0) }
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def set_stats(lives, dmg)
    @lives = lives
    @dmg = dmg
    @curent_lives = @lives
    @curent_dmg = @dmg
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def attacked_hook(attacker)
    attacked_hooks.each do |hook|
      hook.call self, attacker
    end
  end

  def attack_hook(victim)
    attack_hooks.each do |hook|
      hook.call self, victim
    end
  end

  def do_behaviour(_space); end

  def do_animations
    @cur_anim.each do |anim|
      next if anim.nil?
      index = @cur_anim.index anim
      do_animation_on_index index
    end
  end

  def do_animation_on_index(index, force_angle = 0)
    return if @cur_anim[index].nil?

    @cur_anim[index].started = true unless @cur_anim[index].started

    if @cur_anim[index].finished
      @cur_anim[index] = nil
    else
      @cur_anim[index].do_animation @shapes, force_angle
    end
  end

  def set_animation(index, anim, instant = false, force_angle = 0)
    do_animation_on_index index, force_angle if instant
    @cur_anim[index] = anim if @cur_anim[index].nil?
  end

  def over_write_animation(index, anim, instant = false, force_angle = 0)
    do_animation_on_index index, force_angle if instant
    @cur_anim[index] = anim
  end

  def draw
    unless @trigger.nil?
      @trigger.mob_targeter.draw_rot(draw_param[0], draw_param[1] - 40, 2, 0, 0.5, 0.5, @trigger.mob_targeter_ratio, @trigger.mob_targeter_ratio)  if @trigger.shown
    end
  end

  def draw_health
    @health_bar ||= TexPlay.create_blank_image @window, 50, 10, :color => Assets[0xff_6ab60b, :color]
    @health_bar.rect 0, 0, 50.0, 10, :color => Assets[0xff_c1131d, :color], :fill => true
    @health_bar.rect 0, 0, 50.0 * @curent_lives / @lives, 10, :color => Assets[0xff_6ab60b, :color], :fill => true unless @curent_lives == Float::INFINITY
  end
end

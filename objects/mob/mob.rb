require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative '../obj'
MOVEMENT = 0
BEHAVIOUR = 1
EXTRA = 2

class Mob < Obj
  ATTACK_HOOKS = []
  ATTACKED_HOOKS = []

  attr_accessor :cur_anim, :lives, :dmg, :curent_lives, :curent_dmg, :ATTACK_HOOKS, :ATTACKED_HOOKS
  
  def initialize(window, source)
    super window, source
    @cur_anim = Array.new(3)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def set_stats(lives, dmg)
    @lives = lives
    @dmg = dmg
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def attacked_hook(attacker)
    ATTACKED_HOOKS.each do |hook|
      hook.call self, attacker
    end
  end

  def attack_hook(victim)
    ATTACK_HOOKS.each do |hook|
      hook.call self, victim
    end
  end

  def do_behaviour(_space); end

  def do_animations
    @cur_anim.each do |anim|
      next if anim.nil?
      index = @cur_anim.index anim
      do_animation_on_index(index)
    end
  end

  def do_animation_on_index(index)
    return if @cur_anim[index].nil?
    unless @cur_anim[index].started
      @cur_anim[index].started = true
    end
    if @cur_anim[index].finished
      @cur_anim[index] = nil
    else
      @cur_anim[index].do_animation(@shapes)
    end
  end

  def set_animation(index, anim, instant = false)
    do_animation_on_index(index) if instant
    @cur_anim[index] = anim if @cur_anim[index].nil?
  end

  def over_write_animation(index, anim, instant = false)
    do_animation_on_index(index) if instant
    @cur_anim[index] = anim
  end

  def draw(offsetx, offsety)
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0
                    )
  end
end

require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'

# Collision between Player and Platforms
class PlayerPlatformCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    if arbiter.normal(0).y < 0
      arbiter.ignore
      false
    else
      @player.jump = true
    end
    true
  end

  def separate
    @player.jump = false
  end
end

# Collision between Player and polygonal Platforms
class PlayerPlatformPolyCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    @player.jump = true if arbiter.normal(0).y > 0
    true
  end

  def separate
    @player.jump = false
  end
end

# Collision between Player and Spikes
class PlayerSpikeCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    puts 'you are dead' if arbiter.normal(0).y > 0
    true
  end
end

# Collision between Player and Jump Pad
class PlayerJumpPadCollisionHandler
  def initialize(player, level)
    @player = player
    @level = level
  end

  def begin(_a, b, arbiter)
    @level.objects.each do |obj|
      if obj.shapes[0] == b
        @player.body.apply_impulse get_direction_vector(obj) * 6500,
                                   vec2(0, 0) if arbiter.normal(0).y > 0
      end
    end
    true
  end

  def get_direction_vector(obj)
    vec2(Math.cos(obj.body.a), Math.sin(obj.body.a))
  end
end

# Collision between Mobs and the bottom border of the level
class MobBorderCollisionHandler
  def initialize(player, level)
    @player = player
    @level = level
  end

  def begin(_a, b, _arbiter)
    @level.mobs.each do |mob|
      mob.respawn if mob.shapes[0] == b
    end
    true
  end
end

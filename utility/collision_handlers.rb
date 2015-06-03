require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'

# Collision between Player and Platforms
class PlayerPlatformCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(a, _b, arbiter)
    @mob = get_object_from_shape(a, @level)
    @mob.jump = true if arbiter.normal(0).y > 0
    true
  end

  def separate
    @mob.jump = false
  end
end

# Collision between Player and Spikes
class PlayerSpikeCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(_a, _b, arbiter)
    puts 'you are dead' if arbiter.normal(0).y > 0
    true
  end
end

class SwordMobCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(a, b, _arbiter)
    attack_hook(a, b, @level)
    true
  end
end

# Collision between Player and Jump Pad
class MobJumpPadCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(a, b, arbiter)
    a.body.apply_impulse get_direction_vector(b) * 250 * a.body.mass,
                         vec2(0, 0) if arbiter.normal(0).y > 0
    true
  end

  def get_direction_vector(obj)
    vec2 Math.cos(obj.body.a), Math.sin(obj.body.a)
  end
end

# Collision between Mobs and the bottom border of the level
class MobBorderCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(_a, b, _arbiter)
    mob = get_object_from_shape b, @level
    mob.respawn
    true
  end
end

class PlayerSensorCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(a, _b, _arbiter)
    @obj = get_object_from_shape a, @level
    @object_id = @obj.object_id
    @obj.agro = true
    true
  end

  def separate
    @obj = ObjectSpace._id2ref @object_id unless @object_id.nil?
    @obj.agro = false unless @obj.nil?
    @obj = nil
    @object_id = nil
  end
end

class CameraObjectCollisionHandler
  def initialize(level)
    @level = level
  end

  def begin(_a, b, _arbiter)
    @obj = get_object_from_shape b, @level
    @object_id = @obj.object_id
    @obj.should_draw = true
    true
  end

  def pre_solve(_a, b)
    @obj = get_object_from_shape b, @level
    @object_id = @obj.object_id
    @obj.should_draw = true unless @obj.nil?
    true
  end

  def separate
    @obj = ObjectSpace._id2ref @object_id unless @object_id.nil?
    @obj.should_draw = false unless @obj.nil?
    @obj = nil
    @object_id = nil
  end
end

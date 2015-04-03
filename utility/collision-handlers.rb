require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'

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

  def pre_solve(_a, _b)
    true
  end

  def post_solve(_arbiter)
    true
  end

  def separate
    @player.jump = false
  end
end

class PlayerPlatformPolyCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    @player.jump = true if arbiter.normal(0).y > 0
    true
  end

  def pre_solve(_a, _b)
    true
  end

  def post_solve(_arbiter)
    true
  end

  def separate
    @player.jump = false
  end
end

class PlayerSpikeCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    puts 'you are dead' if arbiter.normal(0).y > 0
    true
  end

  def pre_solve(_a, _b)
    true
  end

  def post_solve(_arbiter)
    true
  end
end

class PlayerJumpPadCollisionHandler
  def initialize(player, level)
    @player = player
    @level = level
  end

  def begin(_a, b, arbiter)
    @level.objects.each do |obj|
      if obj.shapes[0] == b
        @player.body.apply_impulse vec2(Math::cos(obj.body.a), Math::sin(obj.body.a)) * 6500, vec2(0, 0) if arbiter.normal(0).y > 0
      end
    end
    true
  end

  def pre_solve(_a, _b)
    true
  end

  def post_solve(_arbiter)
    true
  end
end

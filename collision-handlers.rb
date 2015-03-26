require 'gosu'
require 'chipmunk'

require_relative 'player'
require_relative 'obj'

class PlayerPlatformCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    if arbiter.normal(0).y < 0
      arbiter.ignore
      false
    else
      @player.j = true
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
    @player.j = false
  end
end

class PlayerPlatformPolyCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(_a, _b, arbiter)
    @player.j = true if arbiter.normal(0).y > 0
    true
  end

  def pre_solve(_a, _b)
    true
  end

  def post_solve(_arbiter)
    true
  end

  def separate
    @player.j = false
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

  def separate
  end
end

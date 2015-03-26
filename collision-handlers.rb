require 'gosu'
require 'chipmunk'
require_relative 'player'
require_relative 'obj'

class PlayerPlatformCollisionHandler
  def initialize(player)
    @player = player
  end

  def begin(a, b, arbiter)

    if arbiter.normal(0).y < 0
      arbiter.ignore
      false
    else
      @player.j = true
    end
    true
  end

  def pre_solve(a, b)
    true
  end

  def post_solve(arbiter)
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

  def begin(a, b, arbiter)

    if arbiter.normal(0).y > 0
      puts "you are dead"
    end
    true
  end

  def pre_solve(a, b)
    true
  end

  def post_solve(arbiter)
    true
  end

  def separate
  end
end

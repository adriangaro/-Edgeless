require 'gosu'
require 'chipmunk'

# Numeric
class Numeric
  def radians_to_vec2
    CP::Vec2.new Math::cos(self), Math::sin(self)
  end
end

class Force
  attr_accessor :dir_vec2, :origin_vec2
  def initialize(dir, origin)
    @dir_vec2 = dir
    @origin_vec2 = origin
  end
end

class CP::Body
  def apply_force_s(force)
    apply_force force.dir_vec2, force.origin_vec2
  end

  def apply_impulse_s(impulse)
    apply_impulse impulse.dir_vec2, impulse.origin_vec2
  end
end

def vec2(x, y)
  CP::Vec2.new x, y
end

def sigmoid(t)
  1 / (1 + Math::E ** (-(2 * t - 1) * 5))
end

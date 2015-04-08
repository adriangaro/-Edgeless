require 'gosu'
require 'chipmunk'

# Numeric
class Numeric
  def radians_to_vec2
    CP::Vec2.new Math::cos(self), Math::sin(self)
  end
end

def vec2(x, y)
  CP::Vec2.new x, y
end

def sigmoid(t)
  1 / (1 + Math::E ** (-(2 * t - 1) * 5))
end

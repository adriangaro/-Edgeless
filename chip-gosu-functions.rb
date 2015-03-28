require 'gosu'
require 'chipmunk'

class Numeric
  def radians_to_vec2
    CP::Vec2.new Math::cos(self), Math::sin(self)
  end
end

def vec2(x, y)
  CP::Vec2.new x, y
end

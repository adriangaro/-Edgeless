require 'gosu'
require 'chipmunk'

class Assets
  @textures = {}
  class << self
    def load(window, images)
      images.each do |key, value|
        @textures[key] = Gosu::Image.new window, value
      end
    end

    def [](key)
      @textures[key]
    end
  end
end

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

def cubic_bezier(t , a = 1, b = 0.5, c = 2, d = 0)
  y = 1 - t
  1 - ((y ** 3 * a) + (3 * y ** 2 * t * b) + (3 * y * t ** 2 * c) + (t ** 3 * d))
end


def get_object_from_shape(a, level)
  mob = nil
  level.mobs.each do |obj1|
    obj1.shapes.each do |shape|
      mob = obj1 if shape == a
    end
  end
  obj = nil
  level.objects.each do |obj1|
    obj1.shapes.each do |shape|
      obj = obj1 if shape == a
    end
  end
  back = nil
  level.backgrounds.each do |obj1|
    obj1.shapes.each do |shape|
      back = obj1 if shape == a
    end
  end
  ret = back unless back.nil?
  ret = mob unless mob.nil?
  ret = obj unless obj.nil?
  ret
end

def attack_hook(attacker_shape, victim_shape, level)
  attacker = get_object_from_shape attacker_shape, level
  victim = get_object_from_shape victim_shape, level

  attacker.attack_hook victim unless victim.nil?
  victim.attacked_hook attacker unless victim.nil?
end

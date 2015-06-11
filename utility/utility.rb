require 'gosu'
require 'chipmunk'
require 'texplay'

class Assets
  @textures = {}
  @fonts = {}
  @colors = {}

  class << self
    attr_accessor :textures, :fonts, :colors, :full_health_bar
    def load_textures(window, images)
      images.each do |key, value|
        @textures[key] = Gosu::Image.new window, value
      end
    end

    def load_fonts(window, fonts)
      fonts.each do |key, value|
        @fonts[key] = Gosu::Font.new window, value, 100
      end
    end

    def [](key, which)
      return @textures[key] if which == :texture
      return @fonts[key] if which == :font
      if which == :color
        register_color(key)
        return @colors[key]
      end
    end

    def register_color(key)
      @colors[key] ||= Gosu::Color.new(key)
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

  def *(scalar)
    @dir_vec2 *= scalar
  end

  def /(scalar)
    @dir_vec2 /= scalar
  end

  def rotate(angle)
    @dir_vec2.rotate(angle.radians_to_vec2)
  end

  def rotate!(angle)
    @dir_vec2 = @dir_vec2.rotate(angle.radians_to_vec2)
  end
end

class CP::Body
  def apply_force_s(force)
    apply_force force.dir_vec2 * $delta_factor, force.origin_vec2
  end

  def apply_impulse_s(impulse)
    apply_impulse impulse.dir_vec2 * $delta_factor, impulse.origin_vec2
  end
end

def vec2(x, y)
  CP::Vec2.new x, y
end

def sigmoid_camera(t)
  1 / (1 + Math::E ** (-(2 * t - 1) * 5))
end

def sigmoid_text(t)
  1 + -1 / (1 + Math::E ** (-(2 * (t * 2 - 1).abs - 1) * 12))
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

  victim.class.attacked_hooks.each do |hook|
    hook.call victim, attacker
  end unless victim.nil? && attacker.nil?

  attacker.class.attack_hooks.each do |hook|
    hook.call attacker, victim
  end unless victim.nil? && attacker.nil?
end

module ClassLevelInheritableAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def inheritable_attributes(*args)
      @inheritable_attributes ||= [:inheritable_attributes]
      @inheritable_attributes += args
      args.each do |arg|
        class_eval %(
          class << self; attr_accessor :#{arg} end
        )
      end
      @inheritable_attributes
    end

    def inherited(subclass)
      @inheritable_attributes.each do |inheritable_attribute|
        instance_var = "@#{inheritable_attribute}"
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
    end
  end
end

class String
  def to_bool
    case
    when self == true || self =~ /^(true|t|yes|y|1)$/i
      true
    when self == false || self.nil? || self =~ /^(false|f|no|n|0)$/i
      false
    else
      raise ArgumentError.new "invalid value for Boolean: '#{self}'"
    end
  end

  alias :to_b :to_bool
end

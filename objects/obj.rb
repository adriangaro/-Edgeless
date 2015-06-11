require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'

module Type
  LEVEL_BORDER = 0
  LEVEL_BORDER_BOTTOM = 1
  LEVEL_BACKGROUND = 2
  PLAYER = 3
  PLATFORM = 4
  SPIKE = 5
  MOB = 6
  WEAPON = 7
  JUMP_PAD = 8
  SPIKE_TOP = 9
  CAMERA = 10
  SENSOR = 11
  PROJECTILE = 12

  TYPES = 13
end

module Group
  LEVEL_BORDER = 1
  LEVEL_BACKGROUND = 2
  PLAYER = 3
  PLATFORM = 4
  SPIKE = 5
  MOB = 6
  WEAPON = 7
  JUMP_PAD = 8
  SENSOR = 9
  PROJECTILE = 10
end

module Layer
  # From left to right
  # 1st Bit Background Collision
  # 2nd Bit Weapon Collision
  # 3rd Bit Spike Collision
  # 4th Bit Jump Pad Collision
  # 5th Bit Player Sensor Collision
  # 6th Bit Camera Collision
  # 7th Bit Platform Collision
  # 8th Bit Border Collision
  # 9th Bit Projectile Collision
  NULL_LAYER =       '000000000'.to_i 2
  LEVEL_BORDER =     '110000000'.to_i 2
  LEVEL_BACKGROUND = '000000001'.to_i 2
  PLAYER =           '111001100'.to_i 2
  PLATFORM =         '101000000'.to_i 2
  SPIKE =            '000000100'.to_i 2
  MOB =              '011001110'.to_i 2
  WEAPON =           '000000010'.to_i 2
  JUMP_PAD =         '100001000'.to_i 2
  FULL_LAYER =       '011111111'.to_i 2
  SENSOR =           '000001000'.to_i 2
  PROJECTILE =       '100000000'.to_i 2

end

class Obj
  attr_accessor :shapes, :bodies, :should_draw, :draw_param, :trigger
  def initialize(window)
    @window = window
    @should_draw = false
    @image = nil
    @shapes = []
    @bodies = []
    level_enter_animation_init
  end

  def add_trigger(trigger)
    @trigger = trigger
  end

  def call_trigger(status)
    return if @trigger.nil?
    @trigger.call_from_object self, status
  end

  def destroy
    shapes.each do |shape|
      shape.remove_from_space $level.space
      shape = nil
    end
    bodies.each do |body|
      body.remove_from_space $level.space unless body.mass == Float::INFINITY
      body = nil
    end
    $level.objects.delete self
    $level.mobs.delete self
    @should_draw = false
  end

  def get_draw_param(offsetx, offsety)
    offsetsx = [offsetx]
    offsetsy = [offsety]
    offsetsy << level_enter_animation_do
    color = (@fade_in_level + 1) * 256 * 256 * 256 - 1
    @draw_param = [@bodies[0].p.x - draw_offsets(offsetsx, offsetsy).x,
                   @bodies[0].p.y - draw_offsets(offsetsx, offsetsy).y,
                   @bodies[0].a.radians_to_gosu,
                   Assets[color, :color]]
  end

  def warp(vect)
    @shapes[0].body.p = vect
  end

  def add_to_space(space)
    @bodies.each do |body|
      space.add_body body unless body.mass == Float::INFINITY
    end

    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def add_shapes; end

  def set_shapes_prop; end

  def create_bodies; end

  def level_enter_animation_init
    @time_level = 50.0 * 1 / 60.0
    @miliseconds_level = @time_level  + rand(20) * 1 / 60.0
    @fade_in_level = 0
  end

  def level_enter_animation_do
    @miliseconds_level -= $delta || 0
    if @miliseconds_level >= 0
      @fade_in_level = Integer((1 - @miliseconds_level / @time_level) * 255) if @miliseconds_level > 0 &&   @miliseconds_level < @time_level
      150 * cubic_bezier(@miliseconds_level / @time_level)
    else
      0
    end
  end

  def draw_offsets(offsetsx = [], offsetsy = [])
    ret = vec2 0, 0
    offsetsx.each do |offset|
      ret += vec2 offset, 0
    end
    offsetsy.each do |offset|
      ret += vec2 0, offset
    end
    ret
  end

  def draw(); end
end

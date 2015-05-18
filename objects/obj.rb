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

  TYPES = 11
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
end

module Layer
  # From left to right
  # 1st Bit Border Collision
  # 2nd Bit Platform Collision
  # 3rd Bit -
  # 4th Bit -
  # 5th Bit Spring Collision
  # 6th Bit Spike Collision
  # 7th Bit Weapon Collision
  # 8th Bit Background Collision
  NULL_LAYER =       '00000000'.to_i 2
  LEVEL_BORDER =     '10000000'.to_i 2
  LEVEL_BACKGROUND = '00000001'.to_i 2
  PLAYER =           '11001100'.to_i 2
  PLATFORM =         '01000000'.to_i 2
  SPIKE =            '00000100'.to_i 2
  MOB =              '11001110'.to_i 2
  WEAPON =           '00000010'.to_i 2
  JUMP_PAD =         '00001000'.to_i 2
end

class Obj
  attr_accessor :shapes, :bodies, :draw_img, :should_draw
  def initialize(window, source)
    @window = window
    @should_draw = true
    @image = Gosu::Image.new window, source
    @shapes = []
    @bodies = []
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
    @time_level = 60.0
    @miliseconds_level = @time_level  + rand(20)
  end

  def level_enter_animation_do
    @miliseconds_level -= 1.0
    if @miliseconds_level >= 0
      @fade_in_level = (1 - @miliseconds_level / @time_level) * 255
      200 * cubic_bezier(@miliseconds_level / @time_level)
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

  def draw(offsetx, offsety); end
end

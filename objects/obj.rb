require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'

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
  WEAPON =           '01000010'.to_i 2
  JUMP_PAD =         '00001000'.to_i 2
end

class Obj
  attr_reader :shapes, :bodies, :draw_img
  def initialize(window, source)
    @window = window
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

  def draw; end
end

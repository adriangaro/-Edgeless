require 'gosu'
require 'chipmunk'

require_relative '../utility/chip-gosu-functions'
require_relative 'obj'

class LevelBorder < Obj
  attr_accessor :sizex, :sizey
  def initialize(window, sizex, sizey)
    @g = false
    @window = window
    @shapes = []

    @sizex = sizex
    @sizey = sizey

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(20.0, -20.0),
                                    vec2(-@sizey - 20.0, -20.0),
                                    vec2(-@sizey - 20.0, 0.0),
                                    vec2(20.0, 0.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(20.0, -20.0),
                                    vec2(0.0, -20.0),
                                    vec2(0.0, @sizex + 20.0),
                                    vec2(20.0, @sizex + 20.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(20.0, @sizex),
                                    vec2(-@sizey - 20.0, @sizex),
                                    vec2(-@sizey - 20.0, @sizex + 20.0),
                                    vec2(20.0, @sizex + 20.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(-@sizey, -20.0),
                                    vec2(-@sizey - 20.0, -20.0),
                                    vec2(-@sizey - 20.0, @sizex + 20.0),
                                    vec2(-@sizey, @sizex + 20.0)],
                                   vec2(0, 0))
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = :border
      shape.group = LEVEL_BORDER
    end
  end

  def draw(_offsetx, _offsety)
  end
end

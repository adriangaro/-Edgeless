require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative '../obj'

class LevelBorder < Obj
  attr_accessor :sizex, :sizey
  def initialize(window, sizex, sizey)
    @g = false
    @window = window
    @shapes = []
    @bodies = []
    @should_draw = true
    @sizex = sizex
    @sizey = sizey

    create_bodies
    add_shapes
    set_shapes_prop

    level_enter_animation_init
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(20.0, -20.0),
                                    vec2(-@sizey - 20.0, -20.0),
                                    vec2(-@sizey - 20.0, 0.0),
                                    vec2(20.0, 0.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(20.0, -20.0),
                                    vec2(0.0, -20.0),
                                    vec2(0.0, @sizex + 20.0),
                                    vec2(20.0, @sizex + 20.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(20.0, @sizex),
                                    vec2(-@sizey - 20.0, @sizex),
                                    vec2(-@sizey - 20.0, @sizex + 20.0),
                                    vec2(20.0, @sizex + 20.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(-@sizey, -20.0),
                                    vec2(-@sizey - 20.0, -20.0),
                                    vec2(-@sizey - 20.0, @sizex + 20.0),
                                    vec2(-@sizey, @sizex + 20.0)],
                                   vec2(0, 0))
  end

  def set_shapes_prop
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = Type::LEVEL_BORDER
      shape.group = Group::LEVEL_BORDER
      shape.layers = Layer::LEVEL_BORDER
    end

    @shapes[3].body.p = vec2 0.0, 0.0
    @shapes[3].body.v = vec2 0.0, 0.0
    @shapes[3].e = 0.3
    @shapes[3].body.a = 3 * Math::PI / 2.0
    @shapes[3].collision_type = Type::LEVEL_BORDER_BOTTOM
    @shapes[3].group = Group::LEVEL_BORDER
    @shapes[3].layers = Layer::LEVEL_BORDER
  end

  def create_bodies
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
  end

  def draw()
  end
end

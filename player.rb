require 'gosu'
require 'chipmunk'
require_relative 'chip-gosu-functions'
require_relative 'obj'

SUBSTEPS = 6
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
class Player < Obj
  attr_accessor :j
  def initialize(window, g, source)
    super window, g, source
    @body = CP::Body.new(20.0, 150.0)
    @shape = CP::Shape::Circle.new(body, 64, CP::Vec2.new(0,0))

    @shape.body.p = CP::Vec2.new(0.0, 0.0)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    @shape.e = 1
    @shape.body.a = (3*Math::PI/2.0)
    @shape.collision_type = :ball
  end

  def warp(vect)
    @shape.body.p = vect
  end

  def turn_left
    @shape.body.t -= 600.0/SUBSTEPS
  end

  def turn_right
    @shape.body.t += 600.0/SUBSTEPS
  end

  def accelerate_left
    @shape.body.apply_force((CP::Vec2.new(-1.0, 0.0) * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  def accelerate_right
    @shape.body.apply_force((CP::Vec2.new(1.0, 0.0) * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % SCREEN_WIDTH, @shape.body.p.y % SCREEN_HEIGHT)
    @shape.body.p = l_position
  end

  def jump
    @shape.body.apply_force((CP::Vec2.new(0.0, -1.0) * (50000.0)), CP::Vec2.new(0.0, 0.0)) if @j
  end

  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, 0, @shape.body.a.radians_to_gosu)
  end
end

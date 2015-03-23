require 'gosu'
require 'chipmunk'
require_relative 'chip-gosu-functions'

SUBSTEPS = 6

class Player
  attr_reader :shape, :body

  def initialize(window)
    @image = Gosu::Image.new window, "resources/images/ball.png"

    @body = CP::Body.new(20.0, 150.0)

    @shape = CP::Shape::Circle.new(body, 64, CP::Vec2.new(0,0))
    @shape.collision_type = :ball

    @shape.body.p = CP::Vec2.new(0.0, 0.0)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    @shape.body.a = (3*Math::PI/2.0)
    @shape.e = 2
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

  def accelerate
      @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  def boost_left
    @shape.body.apply_force((CP::Vec2.new(-1.0,0.0) * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end

  def accelerate_left
    @shape.body.apply_force((CP::Vec2.new(-1.0,0.0) * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  def boost_right
    @shape.body.apply_force((CP::Vec2.new(1.0,0.0) * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end

  def accelerate_right
    @shape.body.apply_force((CP::Vec2.new(1.0,0.0) * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  def boost
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end
  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % 640, @shape.body.p.y % 480)
    @shape.body.p = l_position
  end

  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, 0, @shape.body.a.radians_to_gosu)
  end
end

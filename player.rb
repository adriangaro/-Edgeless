require 'gosu'
require 'chipmunk'

require_relative 'chip-gosu-functions'
require_relative 'obj'

SUBSTEPS = 6
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
class Player < Obj
  attr_accessor :j
  def initialize(window, g, diameter)
    super window, g, 'resources/images/ball.png'

    @diameter = diameter

    @body = CP::Body.new 20.0, 150.0
    @shapes << CP::Shape::Circle.new(body, diameter / 2, vec2(0, 0))
    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 1
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = :ball
    end
  end

  def turn_left
    @shapes[0].body.t -= 600.0 / SUBSTEPS
  end

  def turn_right
    @shapes[0].body.t += 600.0 / SUBSTEPS
  end

  def accelerate_left
    @shapes[0].body.apply_force((vec2(-1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
  end

  def accelerate_right
    @shapes[0].body.apply_force((vec2(1.0, 0.0) * (3000.0 / SUBSTEPS)),
                                vec2(0.0, 0.0))
  end

  def validate_position
    l_position = vec2(@shapes[0].body.p.x % SCREEN_WIDTH,
                              @shapes[0].body.p.y % SCREEN_HEIGHT)
    @shapes[0].body.p = l_position
  end

  def jump
    @shapes[0].body.apply_force((vec2(0.0, -1.0) * 90_000.0),
                                vec2(0.0, 0.0)) if @j
  end

  def draw(offsetx, offsety)
    f = @diameter * 1.0 / @image.width
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0.5,
                    0.5,
                    f,
                    f)
  end
end

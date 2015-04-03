require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class JumpPad < Obj
  attr_accessor :angle
  def initialize(window, angle = 0, color = Gosu::Color.new(255, 255, 255))
    @window = window
    @image = polygon_image(color)
    @angle = angle

    @shapes = []

    @body = CP::Body.new Float::INFINITY, Float::INFINITY

    shape_vertices = [vec2(0, 0),
                      vec2(-10, 0),
                      vec2(-10, 50),
                      vec2(0, 50)]
    @shapes << CP::Shape::Poly.new(body, shape_vertices, vec2(0, 0))

    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 1
      shape.body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      shape.collision_type = :jump_pad
      shape.group = Group::JUMP_PAD
      shape.layers = Layer::JUMP_PAD
    end
  end

  def polygon_image(color)
    box_image = Magick::Image.new(2000,
                                  7500) { self.background_color = 'transparent' }
    gc = Magick::Draw.new
    gc.stroke "#" + ("%02x" % color.red) + ("%02x" % color.green) + ("%02x" % color.blue)  + ("%02x" % 255)
    gc.fill "#" + ("%02x" % color.red) + ("%02x" % color.green) + ("%02x" % color.blue)  + ("%02x" % 130)
    gc.stroke_width(1)
    gc.ellipse 25,10, 25, 10, 180, 360
    gc.draw box_image
    puts box_image
    Gosu::Image.new @window, box_image
  end

  def draw(offsetx, offsety)
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0)
  end
end

require 'gosu'
require 'chipmunk'
require 'RMagick'
require 'rubygems'

require_relative '../utility/chip-gosu-functions'
require_relative 'obj'

class PlatformPoly < Obj
  def initialize(window, vertices)
    @window = window
    @shapes = []
    @image = polygon_image(vertices)

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body, vertices, vec2(0, 0))

    @shapes.each do |shape|
      shape.body.p = vec2 0.0, 0.0
      shape.body.v = vec2 0.0, 0.0
      shape.e = 0
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = :platform_poly
      shape.group = Group::PLATFORM
      shape.layers = Layer::PLATFORM
    end
  end

  def polygon_image(vertices)
    maxx = vertices.map { |v| v.x.abs }.max
    maxy = vertices.map { |v| v.y.abs }.max
    puts maxx
    puts maxy
    box_image = Magick::Image.new(maxy + 1,
                                  maxx + 1) { self.background_color = 'transparent' }
    gc = Magick::Draw.new
    gc.stroke 'red'
    gc.fill 'plum'
    draw_vertices = vertices.map { |v| [v.y, v.x.abs] }.flatten
    gc.polygon(*draw_vertices)
    gc.draw box_image
    Gosu::Image.new @window, box_image
  end

  def draw(offsetx, offsety)
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0
                    )
  end
end

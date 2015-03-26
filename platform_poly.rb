require 'gosu'
require 'chipmunk'
require 'RMagick'
require 'rubygems'

require_relative 'chip-gosu-functions'
require_relative 'obj'

EDGE_SIZE = 15

class PlatformPoly < Obj
  def initialize(window, g, vertices)
    @g = g
    @window = window
    @shapes = []
    @image = polygon_image(vertices)

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body, vertices, CP::Vec2.new(0, 0))

    @shapes.each do |shape|
      shape.body.p = CP::Vec2.new 0.0, 0.0
      shape.body.v = CP::Vec2.new 0.0, 0.0
      shape.e = 0.3
      shape.body.a = 3 * Math::PI / 2.0
      shape.collision_type = :platform_poly
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

  def draw
    @image.draw_rot(@shapes[0].body.p.x,
                    @shapes[0].body.p.y,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0
                    )
  end
end

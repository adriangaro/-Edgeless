require 'gosu'
require 'chipmunk'

require_relative 'chip-gosu-functions'
require_relative 'obj'

class Spike < Obj
  def initialize(window, g, sizex, sizey, angle = 0)
    super window, g, 'resources/images/spikes.png'

    @sizex = sizex
    @sizey = sizey

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @shapes << CP::Shape::Poly.new(body,
                                   [CP::Vec2.new(0.0, @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 0.0),
                                    CP::Vec2.new(- @sizey, 2 * @sizex / 8.0)],
                                   CP::Vec2.new(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [CP::Vec2.new(0.0, 3 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 2 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 4 * @sizex / 8.0)],
                                   CP::Vec2.new(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [CP::Vec2.new(0.0, 5 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 4 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 6 * @sizex / 8.0)],
                                   CP::Vec2.new(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [CP::Vec2.new(0.0, 7 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 6 * @sizex / 8.0),
                                    CP::Vec2.new(- @sizey, 8.0 * @sizex / 8.0)],
                                   CP::Vec2.new(0, 0))
    @shapes << CP::Shape::Circle.new(body, 1, CP::Vec2.new(0, @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, CP::Vec2.new(0, 3 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, CP::Vec2.new(0, 5 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, CP::Vec2.new(0, 7 * @sizex / 8.0))

    4.times do |i|
      @shapes[i].body.p = CP::Vec2.new 0.0, 0.0
      @shapes[i].body.v = CP::Vec2.new 0.0, 0.0
      @shapes[i].e = 0.3
      @shapes[i].body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      @shapes[i].collision_type = :spikes
    end
    4.times do |i|
      @shapes[i + 4].body.p = CP::Vec2.new 0.0, 0.0
      @shapes[i + 4].body.v = CP::Vec2.new 0.0, 0.0
      @shapes[i + 4].e = 0.3
      @shapes[i + 4].body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      @shapes[i + 4].collision_type = :spikes_p
    end
  end

  def draw
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x,
                    @shapes[0].body.p.y,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy)
  end
end

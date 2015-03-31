require 'gosu'
require 'chipmunk'

require_relative '../utility/chip-gosu-functions'
require_relative 'obj'

class Spike < Obj
  def initialize(window, sizex, sizey, angle = 0)
    super window, 'resources/images/spikes.png'

    @sizex = sizex
    @sizey = sizey

    @body = CP::StaticBody.new
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(0.0, @sizex / 8.0),
                                    vec2(- @sizey, 0.0),
                                    vec2(- @sizey, 2 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(0.0, 3 * @sizex / 8.0),
                                    vec2(- @sizey, 2 * @sizex / 8.0),
                                    vec2(- @sizey, 4 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(0.0, 5 * @sizex / 8.0),
                                    vec2(- @sizey, 4 * @sizex / 8.0),
                                    vec2(- @sizey, 6 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(body,
                                   [vec2(0.0, 7 * @sizex / 8.0),
                                    vec2(- @sizey, 6 * @sizex / 8.0),
                                    vec2(- @sizey, 8.0 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Circle.new(body, 1, vec2(0, @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, vec2(0, 3 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, vec2(0, 5 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(body, 1, vec2(0, 7 * @sizex / 8.0))

    4.times do |i|
      @shapes[i].body.p = vec2 0.0, 0.0
      @shapes[i].body.v = vec2 0.0, 0.0
      @shapes[i].e = 0.3
      @shapes[i].body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      @shapes[i].collision_type = :spikes
      @shapes[i].group = SPIKE
    end
    4.times do |i|
      @shapes[i + 4].body.p = vec2 0.0, 0.0
      @shapes[i + 4].body.v = vec2 0.0, 0.0
      @shapes[i + 4].e = 0.3
      @shapes[i + 4].body.a = 3 * Math::PI / 2.0 + angle / 180.0 * Math::PI
      @shapes[i + 4].collision_type = :spikes_p
      @shapes[i + 4].group = SPIKE
    end
  end

  def draw(offsetx, offsety)
    fx = @sizex * 1.0 / @image.width
    fy = @sizey * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    0,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy)
  end
end


require 'gosu'
require 'chipmunk'

require_relative '../utility/chip-gosu-functions'
require_relative 'obj'

class Spring < Obj
  attr_accessor :stiffness
  def initialize(window, sizex, rest_length = 150.0, stiffness = 50.0, damping = 0.0)
    super window, 'resources/images/spring.png'

    @sizex = sizex
    @rest_length = rest_length
    @stiffness = stiffness
    @damping = damping

    # @image = polygon_image [vec2(0.0, 0.0),
    #                         vec2(- 20, 0.0),
    #                         vec2(- 20, @sizex),
    #                         vec2(0.0, @sizex)]
    # @image_spring = polygon_image [vec2(0.0, 0.0),
    #                                vec2(- 20, 0.0),
    #                                vec2(- 20, @sizex),
    #                                vec2(0.0, @sizex)]

    @body = CP::Body.new Float::INFINITY, Float::INFINITY
    @body_spring = CP::Body.new 1, Float::INFINITY

    @joint_spring1 = CP::Constraint::DampedSpring.new @body_spring,
                                                      @body,
                                                      vec2(@sizex / 2, 10),
                                                      vec2(@sizex / 2, 10),
                                                      @rest_length,
                                                      @stiffness,
                                                      @damping

    @shapes << CP::Shape::Poly.new(@body,
                                   [vec2(0.0, 0.0),
                                    vec2(- 20, 0.0),
                                    vec2(- 20, @sizex),
                                    vec2(0.0, @sizex)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@body_spring,
                                  [vec2(0.0, 0.0),
                                   vec2(- 20, 0.0),
                                   vec2(- 20, @sizex),
                                   vec2(0.0, @sizex)],
                                  vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@body,
                                  [vec2(20 + 2 * @rest_length, 0),
                                   vec2(20 + 2 * @rest_length, -20.0),
                                   vec2(0.0, -20.0),
                                   vec2(0.0, 0)],
                                  vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@body,
                                  [vec2(20 + 2 * @rest_length, @sizex + 20),
                                   vec2(20 + 2 * @rest_length, @sizex),
                                   vec2(0.0, @sizex),
                                   vec2(0.0, @sizex + 20)],
                                  vec2(0, 0))

    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :spring
    @shapes[0].layers = Layer::SPRING_HELPER

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0
    @shapes[1].body.a = 3 * Math::PI / 2.0
    @shapes[1].collision_type = :spring
    @shapes[1].layers = Layer::SPRING

    @shapes[2].body.p = vec2 0.0, 0.0
    @shapes[2].body.v = vec2 0.0, 0.0
    @shapes[2].e = 0.3
    @shapes[2].body.a = 3 * Math::PI / 2.0
    @shapes[2].layers = Layer::SPRING_HELPER

    @shapes[3].body.p = vec2 0.0, 0.0
    @shapes[3].body.v = vec2 0.0, 0.0
    @shapes[3].e = 0.3
    @shapes[3].body.a = 3 * Math::PI / 2.0
    @shapes[3].layers = Layer::SPRING_HELPER
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect + vec2(0, - @rest_length)
    @shapes[2].body.p = vect
    @shapes[3].body.p = vect
  end

  def add_to_space(space)
    space.add_body @body_spring

    @joint_spring1.add_to_space space

    @shapes.each do |shape|
      space.add_shape shape
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
    fx = @sizex * 1.0 / @image.width
    fy = (@shapes[1].body.p.y - @shapes[0].body.p.y).abs * 1.0 / @image.height
    @image.draw_rot(@shapes[1].body.p.x - offsetx,
                    @shapes[1].body.p.y - offsety,
                    1,
                    @shapes[1].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy)
                    fx = @sizex * 1.0 / @image.width
                    fy = 20 * 1.0 / @image.height
    # @image_spring.draw_rot(@shapes[1].body.p.x - offsetx,
    #                 @shapes[1].body.p.y - offsety,
    #                 1,
    #                 @shapes[1].body.a.radians_to_gosu,
    #                 0,
    #                 0,
    #                 fx,
    #                 fy)

  end
end

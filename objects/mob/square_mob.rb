require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  def initialize(window, finish, color = Gosu::Color.new(232, 86, 86))
    super window, 'resources/images/square_mob.png'
    @window = window

    @finish_pos = finish
    @change = true
    @color = color



    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    @image = polygon_image(@vertices)

    create_bodies
    add_shapes
    set_shapes_prop
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@body,
                                   @vertices,
                                   vec2(0, 0))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :mob
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB
  end

  def create_bodies
    @body = CP::Body.new 10.0, 1000
  end

  def polygon_image(vertices)
    maxx = vertices.map { |v| v.x.abs }.max
    maxy = vertices.map { |v| v.y.abs }.max

    box_image = Magick::Image.new(maxy + 1,
                                  maxx + 1) { self.background_color = 'transparent' }
    gc = Magick::Draw.new
    gc.stroke '#' + @color.red.to_s(16) + @color.green.to_s(16) + @color.blue.to_s(16)  + 255.to_s(16)
    gc.fill '#' + @color.red.to_s(16) + @color.green.to_s(16) + @color.blue.to_s(16)  + 255.to_s(16)
    gc.stroke_width(1)
    draw_vertices = vertices.map { |v| [v.y.abs, v.x.abs] }.flatten
    gc.polygon(*draw_vertices)
    gc.draw box_image
    puts box_image
    Gosu::Image.new @window, box_image
  end


  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
  end

  def add_to_space(space)
    space.add_body @body
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    @dir = ((@finish_pos - @init_pos).x / 0).infinite?

    @change = false if @dir * @shapes[0].body.p.x > @dir * @finish_pos.x

    @change = true if @dir * @shapes[0].body.p.x < @dir * @init_pos.x

    if @change
      @shapes[0].body.apply_force vec2(1, 1) * @dir * 300, vec2(-25, -25)
      @shapes[0].body.ang_vel = @dir * Math::PI / 4
    else
      @shapes[0].body.apply_force vec2(-1, 1) * @dir * 300, vec2(25, -25)
      @shapes[0].body.ang_vel = - @dir * Math::PI / 4
    end
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw(offsetx, offsety)
    fx = 50 * 1.0 / @image.width
    fy = 50 * 1.0 / @image.height
    x = @body.p.x - offsetx
    y = @body.p.y - offsety
    a = @body.a.radians_to_gosu
    @image.draw_rot(x, y, 1, a, 0, 0, fx, fy)
  end
end

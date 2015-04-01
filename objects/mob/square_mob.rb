require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/chip-gosu-functions'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  def initialize(window, finish)
    super window, 'resources/images/square_mob.png'
    @sword = Gosu::Image.new window, 'resources/images/sword.png'
    @window = window

    @finish_pos = finish
    @change = true

    @body = CP::Body.new 10.0, 1000
    @body_weapon = CP::Body.new 10.0, Float::INFINITY

    @joint_body_sword = CP::Constraint::PinJoint.new @body,
                                                     @body_weapon,
                                                     vec2(-25, 25),
                                                     vec2(-65, 10)
    @joint_body_sword.dist = 0
    @joint_body_sword.error_bias = 0.25

    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    @shapes << CP::Shape::Poly.new(@body,
                                   @vertices,
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@body_weapon,
                                   [vec2(-40, -10),
                                    vec2(-40, 10),
                                    vec2(25, 10),
                                    vec2(25, -10)],
                                   vec2(- 25, 10))

    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :mob
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB

    @shapes[1].body.p = vec2 0.0, 0.0
    @shapes[1].body.v = vec2 0.0, 0.0
    @shapes[1].e = 0
    @shapes[1].body.a = 3 * Math::PI / 2.0 - Math::PI / 4
    @shapes[1].collision_type = :sword
    @shapes[1].group = Group::WEAPON
    @shapes[1].layers = Layer::WEAPON
  end

  def polygon_image_debug(vertices)
    maxx = vertices.map { |v| v.x }.max - vertices.map { |v| v.x }.min
    maxy = vertices.map { |v| v.y }.max - vertices.map { |v| v.y }.min
    puts maxx
    puts maxy
    box_image = Magick::Image.new(maxy + 1,
                                  maxx + 1) { self.background_color = 'transparent' }
    gc = Magick::Draw.new
    gc.stroke 'red'
    gc.fill 'plum'
    draw_vertices = vertices.map { |v| [v.y + vertices.map { |v| v.y }.min.abs, v.x + vertices.map { |v| v.x }.min.abs] }.flatten
    gc.polygon(*draw_vertices)
    gc.draw box_image
    Gosu::Image.new @window, box_image
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @shapes[1].body.p = vect
    @init_pos = vect
  end

  def add_to_space(space)
    space.add_body @body
    space.add_body @body_weapon
    @joint_body_sword.add_to_space space
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
      @shapes[1].body.a = 3 * Math::PI / 2.0 + Math::PI / 4
    else
      @shapes[0].body.apply_force vec2(-1, 1) * @dir * 300, vec2(25, -25)
      @shapes[0].body.ang_vel = - @dir * Math::PI / 4
      @shapes[1].body.a = 3 * Math::PI / 2.0 - Math::PI / 4
    end
  end

  def draw(offsetx, offsety)
    fx = 50 * 1.0 / @image.width
    fy = 50 * 1.0 / @image.height
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy
                    )

    fx = 20 * 1.0 / @sword.width
    fy = 65 * 1.0 / @sword.height
    @sword.draw_rot(@shapes[1].body.p.x - offsetx,
                    @shapes[1].body.p.y - offsety,
                    1,
                    @shapes[1].body.a.radians_to_gosu,
                    0,
                    0,
                    fx,
                    fy
                    )
  end
end

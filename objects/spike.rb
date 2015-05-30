require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class Spike < Obj
  def initialize(window, sizex, sizey, angle = 0)
    super window
    @image = Assets["spikes"]

    @sizex = sizex
    @sizey = sizey
    @angle = angle

    @fx = @sizex * 1.0 / @image.width
    @fy = @sizey * 1.0 / @image.height
    create_bodies
    add_shapes
    set_shapes_prop
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(0.0, @sizex / 8.0),
                                    vec2(- @sizey, 0.0),
                                    vec2(- @sizey, 2 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(0.0, 3 * @sizex / 8.0),
                                    vec2(- @sizey, 2 * @sizex / 8.0),
                                    vec2(- @sizey, 4 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(0.0, 5 * @sizex / 8.0),
                                    vec2(- @sizey, 4 * @sizex / 8.0),
                                    vec2(- @sizey, 6 * @sizex / 8.0)],
                                   vec2(0, 0))
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(0.0, 7 * @sizex / 8.0),
                                    vec2(- @sizey, 6 * @sizex / 8.0),
                                    vec2(- @sizey, 8.0 * @sizex / 8.0)],
                                   vec2(0, 0))

    @shapes << CP::Shape::Circle.new(@bodies[0], 1, vec2(0, @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(@bodies[0], 1, vec2(0, 3 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(@bodies[0], 1, vec2(0, 5 * @sizex / 8.0))
    @shapes << CP::Shape::Circle.new(@bodies[0], 1, vec2(0, 7 * @sizex / 8.0))
  end

  def create_bodies
    @bodies << CP::StaticBody.new
  end

  def set_shapes_prop
    set_shapes_body_prop
    set_shapes_body_yop_prop
  end

  def set_shapes_body_prop
    4.times do |i|
      @shapes[i].body.p = vec2 0.0, 0.0
      @shapes[i].body.v = vec2 0.0, 0.0
      @shapes[i].e = 0.3
      @shapes[i].body.a = 3 * Math::PI / 2.0 + @angle / 180.0 * Math::PI
      @shapes[i].collision_type = Type::SPIKE
      @shapes[i].group = Group::SPIKE
      @shapes[i].layers = Layer::SPIKE
    end
  end

  def set_shapes_body_yop_prop
    4.times do |i|
      @shapes[i + 4].body.p = vec2 0.0, 0.0
      @shapes[i + 4].body.v = vec2 0.0, 0.0
      @shapes[i + 4].e = 0.3
      @shapes[i + 4].body.a = 3 * Math::PI / 2.0 + @angle / 180.0 * Math::PI
      @shapes[i + 4].collision_type = Type::SPIKE_TOP
      @shapes[i + 4].group = Group::SPIKE
      @shapes[i + 4].layers = Layer::SPIKE
    end
  end

  def draw()
    if(@should_draw)
      @image.draw_rot(@draw_param[0], @draw_param[1], 1, @draw_param[2], 0, 0, @fx, @fy, Gosu::Color.new(@fade_in_level, 255, 255, 255))
    else
      level_enter_animation_init
    end
  end
end

require 'gosu'
require 'chipmunk'

require_relative '../../utility/utility'
require_relative '../obj'

class LevelBackground < Obj
  attr_accessor :sizex, :sizey
  def initialize(window, name, sizex, sizey)
    @window = window
    @shapes = []
    @bodies = []
    @should_draw = true
    @image = Assets[name]

    @sizex = sizex
    @sizey = sizey

    @fx = @window.width * 1.0 / @image.width
    @fy = @window.height * 1.0 / @image.height
    @trans_dist = 0

    create_bodies
    add_shapes
    set_shapes_prop

    level_enter_animation_init
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   [vec2(- @sizey - 200, - 200),
                                    vec2(- @sizey - 200, @sizex + 200),
                                    vec2(200, @sizex + 200),
                                    vec2(200, - 200)],
                                   vec2(0, 0))
  end

  def set_shapes_prop
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = Type::LEVEL_BACKGROUND
    @shapes[0].group = Group::LEVEL_BACKGROUND
    @shapes[0].layers = Layer::LEVEL_BACKGROUND
  end

  def create_bodies
    @bodies << CP::Body.new(Float::INFINITY, Float::INFINITY)
  end

  def get_draw_param(*)
    f = 0
    min = [$level.player.bodies[0].p.x - (@shapes[0].body.p.x - 200),
           $level.player.bodies[0].p.y - (@shapes[0].body.p.y - 200),
           (@shapes[0].body.p.x + @sizex + 200) - $level.player.bodies[0].p.x,
           (@shapes[0].body.p.y + @sizey + 200) - $level.player.bodies[0].p.y].min
    f = 1 if min > 200
    f = min / 200.0 if min < 200
    @draw_param = Gosu::Color.new 255 * f, 255, 255, 255
end

  def draw
    @image.draw 0, 0, 0, @fx, @fy, @draw_param
  end
end

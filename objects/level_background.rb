require 'gosu'
require 'chipmunk'

require_relative '../utility/utility'
require_relative 'obj'

class LevelBackground < Obj
  attr_accessor :sizex, :sizey, :draw_img
  def initialize(window, source, sizex, sizey)
    @window = window
    @shapes = []

    @image = Gosu::Image.new @window, source

    @sizex = sizex
    @sizey = sizey

    @trans_dist = 0

    @body = CP::Body.new Float::INFINITY, Float::INFINITY

    @shapes << CP::Shape::Poly.new(@body,
                                   [vec2(- @sizey - 200, - 200),
                                    vec2(- @sizey - 200, @sizex + 200),
                                    vec2(200, @sizex + 200),
                                    vec2(200, - 200)],
                                   vec2(0, 0))
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = :background
    @shapes[0].group = Group::LEVEL_BACKGROUND
    @shapes[0].layers = Layer::LEVEL_BACKGROUND
  end

  def draw(level)
    fx = @window.width * 1.0 / @image.width
    fy = @window.height * 1.0 / @image.height

    f = 0

    min = [level.player.body.p.x + 15 - (@shapes[0].body.p.x - 200),
           level.player.body.p.y + 15 - (@shapes[0].body.p.y - 200),
           (@shapes[0].body.p.x + @sizex + 200) - level.player.body.p.x + 15,
           (@shapes[0].body.p.y + @sizex + 200) - level.player.body.p.y + 15].min
    f = 1 if min > 200
    f = min / 200.0 if min < 200
    @image.draw(0,
                0,
                0,
                fx,
                fy,
                Gosu::Color.new(255 * f, 255, 255, 255)) #if @draw_img == true
  end
end

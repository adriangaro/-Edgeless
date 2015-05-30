require 'gosu'
require 'chipmunk'
require 'RMagick'

require_relative '../../utility/utility'
require_relative '../obj'
require_relative 'mob'

class SquareMob < Mob
  attr_accessor :init_pos, :finish_pos
  def initialize(window)
    super window
    @window = window
    @image = Assets["square_mob"]
    @eyes = Assets["square_mob_eyes"]#Gosu::Image.new(window, MAIN_PATH + '/resources/images/square_mob_eyes.png')
    @where = "start"
    @last = vec2(0, 0)
    @ratio = 50.0 / @image.width
    @vertices = [vec2(-50.0, 0.0),
                 vec2(-50.0, 50.0),
                 vec2(0.0, 50.0),
                 vec2(0.0, 0.0)]

    create_bodies
    add_shapes
    set_shapes_prop
    set_stats(500,0)
  end

  def add_shapes
    @shapes << CP::Shape::Poly.new(@bodies[0],
                                   @vertices,
                                   vec2(25, -25))
  end

  def set_shapes_prop
    # result = RubyProf.stop
    # printer = RubyProf::FlatPrinter.new(result)
    # printer.print(STDOUT)
    @shapes[0].body.p = vec2 0.0, 0.0
    @shapes[0].body.v = vec2 0.0, 0.0
    @shapes[0].e = 0.3
    @shapes[0].body.a = 3 * Math::PI / 2.0
    @shapes[0].collision_type = Type::MOB
    @shapes[0].group = Group::MOB
    @shapes[0].layers = Layer::MOB
  end

  def create_bodies
    @bodies << CP::Body.new(10.0, 1000)
  end

  def warp(vect)
    @shapes[0].body.p = vect
    @init_pos = vect
    @finish_pos = vect + vec2(200, 0)
    @dir = 1
  end

  def add_to_space(space)
    space.add_body @bodies[0]
    @shapes.each do |shape|
      space.add_shape shape
    end
  end

  def do_behaviour(space)
    @where = "finish" if (bodies[0].p.x > @finish_pos.x && @finish_pos.x > @init_pos.x) || (bodies[0].p.x < @finish_pos.x && @finish_pos.x < @init_pos.x)
    @where = "start" if  (@finish_pos.x > @init_pos.x && @init_pos.x > bodies[0].p.x) || (@finish_pos.x < @init_pos.x && @init_pos.x < bodies[0].p.x)
    if @where == "start"
      set_animation(MOVEMENT, get_animation("squaremob", "right").dup, true)
    else
      set_animation(MOVEMENT, get_animation("squaremob", "left").dup, true)
    end
    @dir = (@bodies[0].p - @last).x / (@bodies[0].p - @last).x.abs
    @last = vec2(@bodies[0].p.x, @bodies[0].p.y)
  end

  def respawn
    @shapes[0].body.p = @init_pos
  end

  def draw()
    if(@should_draw)
      color = Gosu::Color.new(@fade_in_level, 255, 255, 255)
      @image.draw_rot(@draw_param[0], @draw_param[1], 1, @draw_param[2], 0.5, 0.5, @ratio, @ratio, color)
      @eyes.draw_rot(@draw_param[0] + 5 * @dir,@draw_param[1] - 5, 1, 0, 0.5, 0.5, @ratio * @dir, @ratio, color)
      @health_bar.draw @draw_param[0] - 25, @draw_param[1] + 30, 2
    else
      level_enter_animation_init
    end
  end

  ATTACKED_HOOKS << BaseHooks::KNOCKBACK
end

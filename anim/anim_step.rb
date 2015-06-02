require 'gosu'
require 'chipmunk'
require 'require_all'

require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../objects/platform'
require_relative '../objects/jump_pad'
require_relative '../objects/util/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/utility'
require_relative '../objects/util/level_background'
require_relative '../objects/mob/player'
require_relative '../objects/mob/square_mob'

class AnimationStep
  attr_accessor :move_vect, :angle_change, :layer, :angular_velocity, :force, :impulse
  def initialize(move_vect = vec2(0, 0),
                 angle_change = 0,
                 angular_velocity = 0,
                 layer = -1,
                 force = Force.new(vec2(0, 0), vec2(0, 0)),
                 impulse = Force.new(vec2(0, 0), vec2(0, 0)))
    @move_vect = move_vect
    @angle_change = angle_change
    @layer = layer
    @force = force
    @impulse = impulse
    @angular_velocity = angular_velocity
  end

  def do_step(shape, force_angle = 0)
    shape.body.p += @move_vect
    shape.body.a += @angle_change
    shape.layers = @layer unless @layer == -1

    shape.body.apply_force_s Force.new @force.dir_vec2.rotate(vec2(Math.cos(force_angle),
                                                                   Math.sin(force_angle))),
                                       @force.origin_vec2
    shape.body.apply_impulse_s Force.new @impulse.dir_vec2.rotate(vec2(Math.cos(force_angle),
                                                                       Math.sin(force_angle))),
                                         @impulse.origin_vec2
    shape.body.ang_vel = @angular_velocity
  end
end

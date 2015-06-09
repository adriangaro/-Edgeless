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
require_relative 'anim_step'

NULL_STEP = AnimationStep.new

class Animation
  attr_accessor :finished, :started, :steps, :refference_steps, :current_step, :max_steps
  def initialize
    @steps = []
    @refference_steps = []
    @finished = false
    @started = false
    @current_step = 0
    @max_steps = 0
  end

  def add_step(step, position, body_index)
    @refference_steps[body_index] = [] if @refference_steps[body_index].nil?
    @refference_steps[body_index] << [step, position]

  end

  def add_missing_steps
    @refference_steps.each do |ref_step|
      last = nil
      index = @refference_steps.index ref_step
      distance = -1
      @steps[index] = []
      ref_step.each do |step|
        @steps[index] << step[0] if ref_step.index(step) == 0
        if last.nil?
          last = step
          next
        end
        distance = step[1] - last[1]

        (distance - 1).times do
          @steps[index] << create_mini_step(last, step)
        end

        @steps[index] << create_mini_step_ref(last, step)
        last = step
      end
    end
    @max_steps = @steps[0].length
    @refference_steps = nil
  end

  def create_mini_step(last, step)
    distance = step[1] - last[1]
    AnimationStep.new((step[0].move_vect - last[0].move_vect) / distance,
                      (step[0].angle_change - last[0].angle_change) / distance,
                      last[0].angular_velocity)
  end

  def create_mini_step_ref(last, step)
    distance = step[1] - last[1]
    AnimationStep.new((step[0].move_vect - last[0].move_vect) / distance,
                      (step[0].angle_change - last[0].angle_change) / distance,
                      step[0].angular_velocity,
                      step[0].layer,
                      step[0].force,
                      step[0].impulse)
  end

  def reset
    @finished = false
    @started = true
    @current_step = 0
  end

  def do_animation(shapes, force_angle = 0)
    return if @finished || !@started
    shapes.each do |shape|
      index = shapes.index(shape)
      if !@steps[index].nil?
        @steps[index][@current_step].do_step shape, force_angle
      else
        NULL_STEP.do_step shape
      end
    end
    @current_step += 1 if @current_step <= @max_steps
    @finished = true if @current_step >= @max_steps
    @current_step = 0 if @current_step >= @max_steps
  end
end

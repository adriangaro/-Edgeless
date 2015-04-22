require 'gosu'
require 'chipmunk'
require 'require_all'

require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../objects/platform'
require_relative '../objects/jump_pad'
require_relative '../objects/level_border'
require_relative '../objects/platform_poly'
require_relative '../utility/utility'
require_relative '../objects/level_background'
require_relative '../objects/mob/player'
require_relative '../objects/mob/square_mob'
require_relative 'anim_step'

class Animation
  attr_accessor :finished
  def initialize
    @steps = []
    @refference_steps = []
    @finished = true
    @current_step = 0
    @max_steps = 0
  end

  def add_step(step, position, body_index)
    @refference_steps[body_index] = [] if @refference_steps[body_index].nil?
    @refference_steps[body_index] << [step, position]

  end

  def add_missing_steps
    @refference_steps.each do |body_ref_steps|
      last = nil
      index = @refference_steps.index(body_ref_steps)
      distance = -1
      unless body_ref_steps.nil?
        body_ref_steps.each do |step|
          unless last.nil?
            distance = step[1] - last[1] - 1
            @steps[index] = [] if @steps[index].nil?
            @steps[index] << AnimationStep.new(last[0].move_vect / distance,
                                               last[0].angle_change / distance,
                                               step[0].layer,
                                               last[0].angular_velocity,
                                               last[0].force,
                                               last[0].impulse)
            distance.times do
              @steps[index] << create_mini_step(last, step)
            end
          end
          last = step
        end
        @steps[index] = [] if @steps[index].nil?
        @steps[index] << AnimationStep.new(body_ref_steps.last[0].move_vect / distance,
                                           body_ref_steps.last[0].angle_change / distance,
                                           body_ref_steps.last[0].layer,
                                           body_ref_steps.last[0].angular_velocity,
                                           body_ref_steps.last[0].force,
                                           body_ref_steps.last[0].impulse) unless distance == -1
        @steps[index] << AnimationStep.new(body_ref_steps.last[0].move_vect,
                                           body_ref_steps.last[0].angle_change,
                                           body_ref_steps.last[0].layer,
                                           body_ref_steps.last[0].angular_velocity,
                                           body_ref_steps.last[0].force,
                                           body_ref_steps.last[0].impulse) if distance == -1
      end
    end
    @max_steps = @refference_steps.map! { |x| x.map { |y| y[1] }.max unless x.nil? }.max
    puts @max_steps
    @refference_steps = nil

  end

  def create_mini_step(last, step)
    distance = step[1] - last[1] - 1
    AnimationStep.new((step[0].move_vect - last[0].move_vect) / distance,
                                (step[0].angle_change - last[0].angle_change) / distance,
                                step[0].layer,
                                last[0].angular_velocity)
  end

  def do_animation(bodies)
    bodies.each do |body|
      index = bodies.index(body)
      @steps[index][@current_step].do_step(body) unless @steps[index].nil?
    end
    @current_step += 1 if @current_step <= @max_steps
    @current_step = 0 if @current_step > @max_steps
  end
end

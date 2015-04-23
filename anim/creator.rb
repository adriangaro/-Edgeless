require 'gosu'
require 'chipmunk'
require 'require_all'

require_all 'objects'
require_all 'utility'
require_all 'anim'


module Anims
  KEYWORDS = {"player" => "Anims::PLAYER"}
  PLAYER = {}
end


def create_animations
  Dir.foreach(Dir.pwd + '/anim/anims') do |item|
    next if item == '.' || item == '..'
    animation = Animation.new
    File.open(Dir.pwd + '/anim/anims/' + item, "r") do |f|
      index = -1
      f.each_line do |line|
        args = line.split " "
        index = args[0].to_i if args.size == 1
        if args.size > 1
          move_vect = vec2 0, 0
          angle_change = 0
          layer = -1
          angular_velocity = 0
          force = Force.new vec2(0, 0), vec2(0, 0)
          impulse = Force.new vec2(0, 0), vec2(0, 0)

          pos = args[0].to_i

          args.each do |arg|
            i = args.index(arg)
            unless arg == "default"
              if i == 1
                coord = arg.split(",").map { |x| x.to_i }
                move_vect = vec2 coord[0], coord[1]
              elsif i == 2
                angle_change = arg.to_i * Math::PI / 180
              elsif i == 3
                layer = arg.to_i 2
              elsif i == 4
                angular_velocity = arg.to_i * Math::PI / 180
              elsif i == 5
                coord = arg.split(",").map { |x| x.to_i }
                force = Force.new vec2(coord[0], coord[1]), vec2(coord[2], coord[3])
              elsif i == 6
                coord = arg.split(",").map { |x| x.to_i }
                impulse = Force.new vec2(coord[0], coord[1]), vec2(coord[2], coord[3])
              end
            end
          end
          animation.add_step(AnimationStep.new(move_vect,
                                               angle_change,
                                               angular_velocity,
                                               layer,
                                               force,
                                               impulse),
                             pos,
                             index)
        end
      end
      animation.add_missing_steps
    end
    first_word = item.split("_")[0]
    name = item.split("_").drop(1).join.split(".")[0]
    puts name
    eval(Anims::KEYWORDS[first_word])[name] = animation
  end
end

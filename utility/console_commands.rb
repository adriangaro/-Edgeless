require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'
require_relative 'utility'

MOBS = {"player" => "Player.new $window", "Player" => "Player.new $window", "PLAYER" => "Player.new $window",
        "square" => "SquareMob.new $window"
        }

COMMANDS = {"spawn" => "lambda do |args|
                          args[4] = 1 if args[4].nil?
                          args[4].to_i.times do
                            mob = eval(MOBS[args[1]])
                            mob.warp vec2(args[2].to_i, args[3].to_i)
                            $level.mobs << mob
                            mob.add_to_space $level.space
                          end
                        end"}

Thread.new {
  while (a = gets.chomp)
    args = a.split(" ")
    eval(COMMANDS[args[0]]).call args
  end
}

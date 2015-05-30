require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'
require_relative 'utility'

MOBS = {"player" => Player, "square" => SquareMob}

COMMANDS = {"spawn" => lambda do |args, window, level|
                          args[4] = 1 if args[4].nil?
                          args[4].to_i.times do
                            mob = MOBS[args[1]].new window
                            mob.warp vec2(args[2].to_i, args[3].to_i)
                            level.mobs << mob
                            mob.add_to_space level.space
                            p mob
                          end
                        end}

def start_console_thread(window, level)
  console_thread = Thread.new {
    @window = window
    @level = level
    while (a = gets.chomp)
      args = a.split
      COMMANDS[args[0].downcase].call args, @window, @level
    end
  }
  console_thread.abort_on_exception = true
  console_thread.run
end

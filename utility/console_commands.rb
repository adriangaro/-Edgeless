require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/obj'
require_relative 'utility'

MOBS = { 'player' => Player, 'square_mob' => SquareMob, 'triangle_mob' => TriangleMob }

COMMANDS = {'spawn' => [lambda do |args, window, level|
                          if args[0][-1] == '?'
                            mob_names = ''
                            MOBS.each do |key, value|
                              mob_names += key + ', '
                            end
                            mob_names[-2] = ' '
                            normal_info_message args
                            puts "\tmob_names: " + mob_names
                          else
                            amount = 1
                            amount = [Integer(args[4]), amount].max unless args[4].nil?
                            fail if amount > 300
                            amount.times do
                              mob = MOBS[args[1]].new window
                              mob.warp vec2(Float(args[2]), Float(args[3]))
                              level.mobs << mob
                              mob.add_to_space level.space
                            end
                          end
                        end,
                        "Spawns mobs into level.\n\tUsage: spawn <mob_name : string> <x : float> <y : float> <amount <= 300 : int>."],
            'help' => [lambda do |args, window, level|
                         puts 'List of commands:'
                         COMMANDS.each do |key, value|
                           puts key + ': ' +value[1]
                         end
                       end,
                       "Lists commands.\n\tUsage: help."],
            'close' => [lambda do |args, window, level|
                          window.close
                        end,
                        "Closes game.\n\tUsage: close."]}

def normal_info_message(args)
  puts args[0].split('?')[0]+ ': ' + COMMANDS[args[0].split('?')[0]][1]
end

def start_console_thread(window, level)
  console_thread = Thread.new {
    @window = window
    @level = level
    while (a = gets.chomp)
      args = a.split(' ').map { |x| x.downcase }
      begin
        begin
          COMMANDS[args[0].split('?')[0]][0].call args, @window, @level
        rescue
          puts args[0].split('?')[0]+ ': ' + COMMANDS[args[0].split('?')[0]][1]
        end
      rescue
        puts "This command dosen't exist. Type help for more info!"
      end
    end
  }
  console_thread.abort_on_exception = true
  console_thread.run
end

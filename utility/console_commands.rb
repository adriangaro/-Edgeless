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
                            amount = [Integer(args[2]), 1].max unless args[2].nil?
                            amount = [Integer(args[4]), 1].max unless args[4].nil?

                            fail if amount > 300

                            x = level.player.bodies[0].p.x
                            x = Float(args[2]) if !args[3].nil? && !args[2].nil?

                            y = level.player.bodies[0].p.y
                            y = Float(args[3]) if !args[3].nil? && !args[2].nil?

                            amount.times do
                              TASKS << lambda do
                                mob = MOBS[args[1]].new window
                                mob.warp vec2(x, y)
                                level.mobs << mob
                                mob.add_to_space level.space
                              end
                            end
                          end
                        end,
                        "Spawns mobs into level.\n\tUsage: spawn <mob_name : string> {[x : float] [y : float]} [amount <= 300 : int]."],
            'help' => [lambda do |args, window, level|
                         puts 'List of commands: <arg> means required, [args] means optional, {arg1, arg2 ...} means required togheter.'
                         COMMANDS.sort.each do |key, value|
                           puts key + ': ' +value[1]
                         end
                       end,
                       "Lists commands.\n\tUsage: help."],
            'close' => [lambda do |args, window, level|
                          window.close
                        end,
                        "Closes game.\n\tUsage: close."],
            'kill' => [lambda do |args, window, level|
                         if args[0][-1] == '?'
                           mob_names = ''
                           MOBS.each do |key, value|
                             mob_names += key + ', '
                           end
                           mob_names[-2] = ' '
                           normal_info_message args
                           puts "\tmob_names: " + mob_names
                         else
                           x = level.player.bodies[0].p.x
                           x = Float(args[2]) if !args[3].nil? && !args[2].nil?

                           y = level.player.bodies[0].p.y
                           y = Float(args[3]) if !args[3].nil? && !args[2].nil?

                           vect = vec2(x, y)

                           radius = Integer(args[2]) unless args[2].nil?
                           radius = Integer(args[4]) unless args[4].nil?

                           level.mobs.each do |mob|
                             TASKS << -> { mob.destroy } if mob.bodies[0].p.dist(vect) < radius && mob.class == MOBS[args[1]]
                           end
                         end
                       end,
                       "Kills a specific mob.\n\tUsage: kill <mob_name :string> {[x : float] [y : float]} <radius : float>."],
             'respawn' => [lambda do |args, window, level|
                             level.player.respawn
                             level.player.curent_lives = level.player.lives
                           end,
                           "Respawn player and heals him.\n\tUsage: respawn."],
             'invincible' => [lambda do |args, window, level|
                                fail if args[1].nil?
                                if args[1].to_b
                                  level.player.curent_lives = Float::INFINITY
                                else
                                  level.player.curent_lives = level.player.lives
                                end
                              end,
                              "Turns on or off invincibility on player.\n\tUsage: invincible <true / false>"]}

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

require 'gosu'
require 'chipmunk'
require 'require_all'

require_all 'levels'
require_all 'objects'
require_all 'utility'
require_all 'anim'

MAIN_PATH = File.expand_path(File.dirname(__FILE__))
TASKS ||= []

class GameWindow < Gosu::Window
  def initialize
    super Gosu::screen_width, Gosu::screen_height, false
    self.caption = 'Edgeless'
    initialize_level
    initialize_camera
    add_collision_handlers
    create_animations
    $delta = 1 / 60.0
    @last = Time.now
    $level.space.step 1 / 60.0
  end

  def initialize_level
    $level = First.new self
  end

  def initialize_camera
    @camera = CameraEdgeless.new vec2($level.player.bodies[0].p.x, $level.player.bodies[0].p.y),
                                 self,
                                 $level
    initialize_camera_behaviour
  end

  def initialize_camera_behaviour
    @offset = vec2 0, 0
    @miliseconds = -1

    @old_point = @camera.p
    @new_point = @camera.get_offset($level.player) + @old_point
  end

  def add_collision_handlers
    $level.space.add_collision_handler Type::PLAYER,
                                       Type::PLATFORM,
                                       PlayerPlatformCollisionHandler.new($level)
    $level.space.add_collision_handler Type::PLAYER,
                                       Type::SPIKE_TOP,
                                       PlayerSpikeCollisionHandler.new($level)
    $level.space.add_collision_handler Type::WEAPON,
                                       Type::MOB,
                                       SwordMobCollisionHandler.new($level)
    $level.space.add_collision_handler Type::PLAYER,
                                       Type::JUMP_PAD,
                                       MobJumpPadCollisionHandler.new($level)
    $level.space.add_collision_handler Type::MOB,
                                       Type::JUMP_PAD,
                                       MobJumpPadCollisionHandler.new($level)
    $level.space.add_collision_handler Type::LEVEL_BORDER_BOTTOM,
                                       Type::MOB,
                                       MobBorderCollisionHandler.new($level)
    $level.space.add_collision_handler Type::LEVEL_BORDER_BOTTOM,
                                       Type::PLAYER,
                                       MobBorderCollisionHandler.new($level)
    Type::TYPES.times do |x|
      $level.space.add_collision_handler Type::CAMERA,
                                         x,
                                         CameraObjectCollisionHandler.new($level)
    end
  end

  def delta_time
    ret =(Time.now - @last)
    @last = Time.now
    [ret, 1 / 60.0].max
  end

  def update
    $delta = delta_time
    $level.space.gravity = $level.gravity * 1 / 60.0 / $delta
    start_console_thread(self, $level) if $level.player.miliseconds_level < 0
    if $level.player.miliseconds_level < 0
      SUBSTEPS.times do
        add_keyboard_controls

        $level.mobs.each do |mob|
          mob.should_draw = false
          mob.shapes[0].body.reset_forces
          # mob.do_behaviour $level.space
        end

        $level.objects.each do |obj|
          obj.should_draw = false
        end

        @draw_off = @camera.get_draw_offset $level
        $level.camera.follow_camera(@draw_off.x, @draw_off.y)
        $level.space.reindex_static
        $level.space.step $delta
        TASKS.each &:call
        $level.mobs.compact!
      end
      camera_behaviour
    end
    @draw_off = @camera.get_draw_offset $level
    $level.mobs.each do |mob|
      mob.get_draw_param @draw_off.x, @draw_off.y
    end
    $level.objects.each do |mob|
      mob.get_draw_param @draw_off.x, @draw_off.y
    end
    $level.backgrounds.each do |mob|
      mob.get_draw_param
    end
  end

  def camera_behaviour
    @old_point = @camera.p

    @time = 450.0

    if @camera.get_offset($level.player).x != 0 || @camera.get_offset($level.player).y != 0
      @miliseconds = @time - 100
      @new_point = @camera.get_offset($level.player) + @old_point
      @camera.moving = true
    end

    if @miliseconds > 0
      @offset = @old_point * (1 - sigmoid((@time - @miliseconds) / @time)) + @new_point * sigmoid((@time - @miliseconds) / @time)
      @miliseconds -= 17
    else
      @offset = @new_point if @camera.moving
      @camera.moving = false
    end

    @camera.p = @offset
    @camera.set_borders
  end

  def add_keyboard_controls
    if button_down? Gosu::KbLeft
      $level.player.turn_left
      $level.player.accelerate_left
    end
    if button_down? Gosu::KbRight
      $level.player.turn_right
      $level.player.accelerate_right
    end

    close if button_down? Gosu::KbEscape

    $level.player.attack if button_down? Gosu::KbZ

    $level.player.jump if button_down? Gosu::KbSpace
  end

  def draw

      time1 = Time.now
    $level.objects.each do |obj|
      obj.draw
    end

    $level.mobs.each do |mob|
      mob.draw
    end

    $level.backgrounds.each do |background|
      background.draw
    end
    puts Time.now - time1
  end
end


$window = GameWindow.new
$window.show

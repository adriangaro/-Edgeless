require 'gosu'
require 'chipmunk'
require 'require_all'

require_all 'levels'
require_all 'objects'
require_all 'utility'
require_all 'anim'

class GameWindow < Gosu::Window
  def initialize
    super 800, 600, false
    self.caption = 'Edgeless'

    initialize_level
    initialize_camera
    add_collision_handlers
    create_animations
  end

  def initialize_level
    @level = Test.new self
    @dt = 1.0 / 60.0
  end

  def initialize_camera
    @camera = CameraEdgeless.new vec2(@level.player.bodies[0].p.x, @level.player.bodies[0].p.y),
                         self
    initialize_camera_behaviour
  end

  def initialize_camera_behaviour
    @offset = vec2 0, 0
    @miliseconds = -1

    @old_point = @camera.p
    @new_point = @camera.get_offset(@level.player) + @old_point
  end

  def add_collision_handlers
    @level.space.add_collision_handler :ball,
                                       :platform,
                                       PlayerPlatformCollisionHandler.new(@level.player)
    @level.space.add_collision_handler :ball,
                                       :platform_poly,
                                       PlayerPlatformPolyCollisionHandler.new(@level.player)
    @level.space.add_collision_handler :ball,
                                       :spikes_p,
                                       PlayerSpikeCollisionHandler.new(@level.player)
    @level.space.add_collision_handler :ball,
                                       :jump_pad,
                                       PlayerJumpPadCollisionHandler.new(@level.player, @level)
    @level.space.add_collision_handler :border_bottom,
                                       :mob,
                                       MobBorderCollisionHandler.new(@level.player, @level)
    @level.space.add_collision_handler :border_bottom,
                                       :ball,
                                       MobBorderCollisionHandler.new(@level.player, @level)
  end

  def update
    SUBSTEPS.times do
      @level.mobs.each do |mob|
        mob.shapes[0].body.reset_forces
        mob.do_behaviour @level.space
      end

      add_keyboard_controls

      @level.space.step @dt
    end
    puts SUBSTEPS
    camera_behaviour
  end

  def camera_behaviour
    @old_point = @camera.p

    @time = 450.0

    if @camera.get_offset(@level.player).x != 0 || @camera.get_offset(@level.player).y != 0
      @miliseconds = @time - 100
      @new_point = @camera.get_offset(@level.player) + @old_point
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
      @level.player.turn_left
      @level.player.accelerate_left
    end
    if button_down? Gosu::KbRight
      @level.player.turn_right
      @level.player.accelerate_right
    end

    close if button_down? Gosu::KbEscape

    @level.player.attack if button_down? Gosu::KbZ

    @level.player.jump if button_down? Gosu::KbSpace
  end

  def draw
    draw_off = @camera.get_draw_offset @level

    @level.objects.each do |obj|
      obj.draw draw_off.x, draw_off.y
    end

    @level.mobs.each do |mob|
      mob.draw draw_off.x, draw_off.y
    end

    @level.backgrounds.each do |background|
      background.draw @level
    end
  end
end

window = GameWindow.new
window.show

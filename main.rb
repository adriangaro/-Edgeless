require 'gosu'
require 'chipmunk'
require 'require_all'

require_all 'levels'
require_all 'objects'
require_all 'utility'

class GameWindow < Gosu::Window
  attr_accessor :file_path
  def initialize
    super 640, 480, false
    self.caption = 'Edgeless'

    @level = First.new self

    @camera = Camera.new vec2(width / 2, height / 2), self

    @offsetx = 0
    @offsety = 0
    @miliseconds = -1

    @old_pointx = @camera.p.x
    @old_pointy = @camera.p.y

    @new_pointx = @camera.get_offset(@level.player).x + @old_pointx
    @new_pointy = @camera.get_offset(@level.player).y + @old_pointy

    @dt = 1.0 / 60.0

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
  end

  def update
    SUBSTEPS.times do
      @level.mobs.each do |mob|
        mob.shapes[0].body.reset_forces
        mob.do_behaviour @level.space
      end

      @level.player.do_behaviour @level.space
      if button_down? Gosu::KbLeft
        @level.player.turn_left
        @level.player.accelerate_left
      end
      if button_down? Gosu::KbRight
        @level.player.turn_right
        @level.player.accelerate_right
      end

      @level.player.attack if button_down? Gosu::KbZ

      @level.player.jump if button_down? Gosu::KbSpace

      @level.space.step @dt
    end

    @old_pointx = @camera.p.x
    @old_pointy = @camera.p.y

    if @camera.get_offset(@level.player).x != 0 || @camera.get_offset(@level.player).y != 0
      @miliseconds = 500
      @miliseconds = 400 if @camera.moving
      @new_pointx = @camera.get_offset(@level.player).x + @old_pointx
      @new_pointy = @camera.get_offset(@level.player).y + @old_pointy
      @camera.moving = true
    end

    if @miliseconds > 0
      @offsetx = @old_pointx * (1 - sigmoid((500 - @miliseconds) / 500.0)) + @new_pointx * sigmoid((500 - @miliseconds) / 500.0)
      @offsety = @old_pointy * (1 - sigmoid((500 - @miliseconds) / 500.0)) + @new_pointy * sigmoid((500 - @miliseconds) / 500.0)
      @miliseconds -= 17
    else
      @offsetx = @new_pointx if @camera.moving
      @offsety = @new_pointy if @camera.moving
      @camera.moving = false
    end

    @camera.p.x = @offsetx
    @camera.p.y = @offsety
    @camera.set_borders
  end

  def draw
    draw_offx = @camera.p.x - width / 2
    draw_offy = @camera.p.y - height / 2

    draw_offx = 0 if @camera.p.x < width / 2
    draw_offy = 0 if @camera.p.y < height / 2

    draw_offx = @level.level_border.sizex - width if @camera.p.x > @level.level_border.sizex - width / 2
    draw_offy = @level.level_border.sizey - height if @camera.p.y > @level.level_border.sizey - height / 2

    @level.objects.each do |obj|
      obj.draw draw_offx, draw_offy
    end

    @level.mobs.each do |mob|
      mob.draw draw_offx, draw_offy
    end

    @level.backgrounds.each do |background|
      background.draw @level
    end
  end
end

window = GameWindow.new
window.show

require 'gosu'
require 'chipmunk'
require 'require_all'

require_all 'levels'

require_relative 'player'
require_relative 'spike'
require_relative 'obj'
require_relative 'collision-handlers'
require_relative 'platform'
require_relative 'level_border'
require_relative 'platform_poly'
require_relative 'chip-gosu-functions'


class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = 'Edgeless'

    @level = First.new self

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
  end

  def update
    SUBSTEPS.times do
      @level.player.shapes[0].body.reset_forces

      if button_down? Gosu::KbLeft
        @level.player.turn_left
        @level.player.accelerate_left
      end
      if button_down? Gosu::KbRight
        @level.player.turn_right
        @level.player.accelerate_right
      end
      @level.player.jump if button_down? Gosu::KbSpace

      @level.objects.each do |obj|
        obj.do_gravity 400
      end

      @level.space.step @dt
    end
  end

  def draw
    @level.objects.each do |obj|
      # Middle Screen
      obj.draw -width / 2 + @level.player.body.p.x,
               -height / 2 + @level.player.body.p.y if @level.player.body.p.x >= width / 2 &&
                                                       @level.player.body.p.y >= height / 2 &&
                                                       @level.player.body.p.y <= @level.level_border.sizey - height / 2 &&
                                                       @level.player.body.p.x <= @level.level_border.sizex - width / 2
      # Left Screen
      obj.draw 0,
               -height / 2 + @level.player.body.p.y if @level.player.body.p.x < width / 2 &&
                                                       @level.player.body.p.y >= height / 2 &&
                                                       @level.player.body.p.y <= @level.level_border.sizey - height / 2

      # Top Screen
      obj.draw -width / 2 + @level.player.body.p.x,
               0 if @level.player.body.p.x >= width / 2 &&
                    @level.player.body.p.y < height / 2 &&
                    @level.player.body.p.x <= @level.level_border.sizex - width / 2
      # Top Left Corner
      obj.draw 0,
               0 if @level.player.body.p.x < width / 2 &&
                    @level.player.body.p.y < height / 2

      # Bottom Left Corner
      obj.draw 0,
               @level.level_border.sizey - height if @level.player.body.p.x < width / 2 &&
                                                     @level.player.body.p.y > @level.level_border.sizey - height / 2
      # Bottom Screen
      obj.draw -width / 2 + @level.player.body.p.x,
               @level.level_border.sizey - height if @level.player.body.p.x >= width / 2 &&
                                                     @level.player.body.p.y > @level.level_border.sizey - height / 2 &&
                                                     @level.player.body.p.x <= @level.level_border.sizex - width / 2
      # Top Right Corner
      obj.draw @level.level_border.sizex - width,
               0 if @level.player.body.p.x > @level.level_border.sizex - width / 2 &&
                    @level.player.body.p.y < height / 2
      # Rigth Screen
      obj.draw @level.level_border.sizex - width,
               -height / 2 + @level.player.body.p.x if @level.player.body.p.x > @level.level_border.sizex - width / 2 &&
                                                       @level.player.body.p.y >= height / 2
                                                       @level.player.body.p.y <= @level.level_border.sizey - height / 2 &&
                                                       @level.player.body.p.x <= @level.level_border.sizex - width / 2
      # Bottom Right Corner
      obj.draw @level.level_border.sizex - width,
               @level.level_border.sizey - height if @level.player.body.p.x > @level.level_border.sizex - width / 2 &&
                                                     @level.player.body.p.y > @level.level_border.sizey - height / 2
    end
  end
end

window = GameWindow.new
window.show

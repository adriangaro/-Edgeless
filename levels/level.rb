require 'gosu'
require 'chipmunk'

require_relative '../objects/mob/player'
require_relative '../objects/spike'
require_relative '../objects/obj'
require_relative '../objects/platform'
require_relative '../objects/util/level_background'
require_relative '../objects/util/level_border'
require_relative '../objects/util/camera_collider'
require_relative '../objects/platform_poly'
require_relative '../utility/utility'

class Level
  attr_accessor :objects, :mobs, :backgrounds, :player, :level_border, :space, :camera, :width, :height

  def initialize(window, sizex, sizey)
    @window = window
    load window
    @space = CP::Space.new
    @objects = []
    @mobs = []
    @backgrounds = []

    @width = sizex
    @height = sizey

    @level_border = LevelBorder.new @window, sizex, sizey
    @objects << @level_border
    @level_border.warp vec2 0, 0

    @camera = CameraColliderObject.new @window
    @objects << @camera
    @camera.warp vec2 0, 0

    @player = Player.new @window
    @mobs << @player
  end

  def load(window)
    dir = Dir['resources/images/*.png']
    images = {}
    dir.each do |path|
      images[path.split('/').last.split('.').first] = path
    end
    Assets.load(window, images)
  end

  def warp_player(x, y)
    @player.warp vec2 x, y
  end

  def add_object(obj, x, y)
    @objects << obj
    obj.warp vec2 x, y
  end

  def add_mob(mob, x, y)
    @mobs << mob
    mob.warp vec2 x, y
  end

  def add_background(background, x, y)
    @backgrounds << background
    background.warp vec2 x, y
  end

  def init_level
    @objects.each do |obj|
      obj.add_to_space @space
    end
    @mobs.each do |mob|
      mob.add_to_space @space
    end
    @backgrounds.each do |background|
      background.add_to_space @space
    end
  end

  def warp
  end
end

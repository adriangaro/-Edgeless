require 'chipmunk'

require_relative 'utility'

# Camera
class CameraEdgeless
  attr_accessor :p, :moving
  def initialize(vect, window, level)
    @p = vect
    @window = window
    @moving = false
    @level = level
    set_borders
  end

  def set_borders
    set_horizontal_borders
    set_vertical_borders
  end

  def set_horizontal_borders
    @left_border = @p.x - @window.width / 4
    @right_border = @p.x + @window.width / 4
  end

  def set_vertical_borders
    @up_border = @p.y - @window.height / 4
    @down_border = @p.y + @window.height / 4
  end

  def get_offset(player)
    offsetx = get_offsetx player
    offsety = get_offsety player
    vec2(offsetx, offsety)
  end

  def get_offsetx(player)
    position = player.bodies[0].p

    offsetx = 0
    offsetx = position.x - @right_border if position.x > @right_border
    offsetx = position.x - @left_border if position.x < @left_border
    offsetx = 0 if @level.level_border.sizex < Gosu::screen_width && @level.level_border.sizex < @window.width
    offsetx
  end

  def get_offsety(player)
    position = player.bodies[0].p

    offsety = 0
    offsety = position.y - @down_border if position.y > @down_border
    offsety = position.y - @up_border if position.y < @up_border
    offsety = 0 if @level.level_border.sizey < Gosu::screen_height && @level.level_border.sizey < @window.height
    offsety
  end

  def get_draw_offset(level)
    draw_off = vec2 0, 0

    draw_off.x = get_draw_offsetx level
    draw_off.y = get_draw_offsety level

    draw_off
  end

  def get_draw_offsetx(level)
    sizex = level.level_border.sizex

    return 0 if @p.x < @window.width / 2
    return sizex - @window.width if @p.x > sizex - @window.width / 2
    @p.x - @window.width / 2
  end

  def get_draw_offsety(level)
    sizey = level.level_border.sizey

    return 0 if @p.y < @window.height / 2
    return sizey - @window.height if @p.y > sizey - @window.height / 2
    @p.y - @window.height / 2
  end
end

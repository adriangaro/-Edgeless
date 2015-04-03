require 'chipmunk'

require_relative 'utility'

class Camera
  attr_accessor :p, :moving
  def initialize(vect, window)
    @p = vect
    @window = window
    @moving = false

    @left_border = @p.x - @window.width / 4
    @right_border = @p.x + @window.width / 4
    @up_border = @p.y - @window.height / 4
    @down_border = @p.y + @window.height / 4
  end

  def set_borders
    @left_border = @p.x - @window.width / 6
    @right_border = @p.x + @window.width / 6
    @up_border = @p.y - @window.height / 4
    @down_border = @p.y + @window.height / 4
  end

  def get_offset(player)
    offsetx = 0
    offsetx = player.body.p.x - @right_border if player.body.p.x > @right_border
    offsetx = player.body.p.x - @left_border if player.body.p.x < @left_border

    offsety = 0
    offsety = player.body.p.y - @down_border if player.body.p.y > @down_border
    offsety = player.body.p.y - @up_border if player.body.p.y < @up_border

    return vec2(offsetx, offsety)
  end
end

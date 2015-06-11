class MoveTrigger < Trigger
  def initialize(x, y, radius, message = "", shown = false, rank = 'sec')
    super message, shown, rank
    @pos = vec2(x, y)
    @radius = radius
  end

  def check_requirements
    $level.player.bodies[0].p.dist(@pos) < @radius
  end

  def show_target
    ratio = 30.0 / @targeter.width
    a = Math::PI

    if $window.camera.p.x + $window.width / 2 < @pos.x
      x = $window.width - 30
      a = 0
    elsif $window.camera.p.x - $window.width / 2 > @pos.x
      x = 30
      a = Math::PI
    else
      x = @pos.x - $window.camera.get_draw_offset($level).x
    end

    if $window.camera.p.y + $window.height / 2 < @pos.y
      y = $window.height - 30
      a = 3 * Math::PI / 2
    elsif $window.camera.p.y - $window.width / 2 > @pos.y
      y = 30
      a = 1 * Math::PI / 2
    else
      y = @pos.y - $window.camera.get_draw_offset($level).y
    end

    if @area.nil?
      @area ||= TexPlay.create_blank_image $window, @radius * 2 + 2, @radius * 2 + 2
      @area.circle @radius, @radius, @radius, :color => Assets[COLORS[@rank + '_fill'], :color], :fill => true
    end

    TASKS << lambda do
      DRAW_TASKS << lambda do
        @area.draw(@pos.x - $window.camera.get_draw_offset($level).x - @radius,
                   @pos.y - $window.camera.get_draw_offset($level).y - @radius,
                   1)
      end
    end
    DRAW_TASKS << lambda do
      @targeter.draw_rot(x,
                         y,
                         1,
                         a,
                         0.5,
                         0.5,
                         ratio,
                         ratio)
    end unless x == @pos.x - $window.camera.get_draw_offset($level).x && y == @pos.y - $window.camera.get_draw_offset($level).y
  end

  def trigger
    success if check_requirements
  end
end

class SummonTrigger < Trigger
  def initialize(x, y, data, radius, radius_rand, ticks, message = "", shown = false, rank = 'sec')
    super message, shown, rank
    @pos = vec2(x, y)

    @radius = radius

    @offset = radius_rand
    @data = data
    @delta_ticks = ticks

    @count_alive = 0
    @data.each { |value| @count_alive += value[1]}

    @rem_ticks = ticks
    @mob_targeter = Assets['kill_targeter_' + @rank, :texture]
    @mob_targeter_ratio = 30.0 / @mob_targeter.width
  end

  def call_from_object(obj, status)
    @count_alive -= 1 if status == :dead
  end

  def check_requirements
    $level.player.bodies[0].p.dist(@pos) < @radius
  end

  def trigger
    success if @count_alive <= 0
    return unless check_requirements
    if @rem_ticks == 0 && !@data.empty?
      @data[0][1] -= 1
      @rem_ticks = @delta_ticks

      mob = @data[0][0].new $window

      ran = Random.new
      x1 = ran.rand(@offset * 2) - @offset
      mob.warp @pos + vec2(x1, 0)

      $level.mobs << mob
      mob.add_to_space $level.space
      mob.add_trigger self

      @data.delete_if { |value| value[1] == 0 }
    end
    @rem_ticks -= 1
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
      end unless @data.empty?
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
end

class KillTrigger < Trigger
  def initialize(data, message = "", shown = false, rank = 'sec')
    super message, shown, rank
    @data = data

    @count_alive = @data.length
    @data.each { |x| x.add_trigger self }

    @mob_targeter = Assets['kill_targeter_' + @rank, :texture]
    @mob_targeter_ratio = 30.0 / @mob_targeter.width
  end

  def call_from_object(obj, status)
    @count_alive -= 1 if status == :dead
  end

  def trigger
    success if @count_alive <= 0
  end
end



class Routine
  module RoutineStates
    RUNNING = 0
    SUCCESS = 1
    FAILURE = 2
  end

  attr_accessor :state

  def start
    @state = RoutineStates.RUNNING
  end

  def reset; end

  def act(_space); end

  def succeed
    @state = RoutineStates.SUCCESS
  end

  def fail
    @state = RoutineStates.FAILURE
  end

  def succes?
    @state == RoutineStates.SUCCESS
  end

  def running?
    @state == RoutineStates.RUNNING
  end

  def failed?
    @state == RoutineStates.FAILURE
  end
end

class StackFSM
  def initialize
    @stack = []
  end

  def update
    get_current_state.call unless get_current_state.nil?
  end

  def pop_state
    @stack.pop
  end

  def push_state(state)
    @stack.push state
  end

  def get_current_state
    @stack.last || nil
  end
end

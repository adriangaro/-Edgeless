require 'chipmunk'

class Trigger
  attr_accessor :children, :parent, :shown, :mob_targeter, :mob_targeter_ratio
  COLORS = {"sec_margin" => 0xff_7f8083,
            "sec_fill" => 0x44_7f8083,
            "prin_margin" => 0xff_eba816,
            "prin_fill" => 0x44_eba816}
  class ParentingException < Exception
    def initialize(child)
      @child = child
    end

    def message
      "#{@child} is already added to a parent or the parent is the same as the child, can't be added again."
    end
  end

  class RankException < Exception
    def message
      "Wrong rank given as argument, should be sec or prin!"
    end
  end

  def initialize(message = '', shown = false, rank = 'sec')
    @message = message
    @shown = shown
    raise RankException.new unless rank =~ /^(sec|prin)$/i
    @rank = rank
    @children = []
    @targeter = Assets['targeter_' + @rank, :texture]
  end

  def check_requirements; end

  def add_child(child)
    raise ParentingException.new(child) if child.parent == self || child == self
    @children ||= []
    @children << child
    child.parent = self
    rescue ParentingException => detail
      print detail.message + "\n\t"
      print detail.backtrace.join("\n\t")
  end

  def call_from_object(obj, status); end

  def call_trigger
    return unless @children.empty?
    trigger
    show_target if @shown
  end

  def show_target; end

  def trigger; end

  def success
    MESSAGE_TASKS << [lambda { |color| Assets['timeburner_regular', :font].draw_rel(@message,
                                                                                    $window.width / 2,
                                                                                    $window.height / 2,
                                                                                    3,
                                                                                    0.5,
                                                                                    0.5,
                                                                                    1,
                                                                                    1,
                                                                                    color)},
                      120 + @message.length * 5,
                      Assets[COLORS[@rank + '_margin'], :color],
                      120 + @message.length * 5]
    $level.triggers.delete_if { |key, value| value == self}
    @parent.children.delete self unless @parent.nil?
  end
end

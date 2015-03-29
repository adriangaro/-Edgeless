require 'gosu'
require 'chipmunk'

require_relative '../utility/chip-gosu-functions'

class Obj
  attr_reader :shapes, :body
  def initialize(window, source)
    @image = Gosu::Image.new window, source
    @shapes = []
  end

  def warp(vect)
    @shapes[0].body.p = vect
  end

  def add_to_space(space)
    space.add_body @body unless @body.mass == Float::INFINITY
    @shapes.each do |shape|
      space.add_shape shape
    end
  end
end

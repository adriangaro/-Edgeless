require 'gosu'
require 'chipmunk'

require_relative '../../utility/chip-gosu-functions'
require_relative '../obj'

class Mob < Obj
  def initialize(window, source)
    super window, source
  end

  def do_behaviour(_space)
  end

  def draw(offsetx, offsety)
    @image.draw_rot(@shapes[0].body.p.x - offsetx,
                    @shapes[0].body.p.y - offsety,
                    1,
                    @shapes[0].body.a.radians_to_gosu,
                    0,
                    0
                    )
  end
end

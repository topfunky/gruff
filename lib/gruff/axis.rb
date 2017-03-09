##
# Original Author: Hoang Nguyen Minh
#
# This class contains data for secondary y axis
#
class Gruff::Axis
  attr_accessor :label

  attr_accessor :label_color

  attr_accessor :label_font

  attr_accessor :line_color

  attr_accessor :shadow_color

  attr_accessor :font_size

  attr_accessor :maximum_value

  attr_accessor :minimum_value

  attr_accessor :count

  attr_accessor :increment

  attr_accessor :format

  attr_accessor :skip_lines

  attr_accessor :stroke_dash

  attr_accessor :stroke_opacity

  attr_accessor :m_increment

  attr_accessor :m_spread

  attr_accessor :m_offset

  def initialize
    @label = nil
    @label_color = 'black'
    @label_font = nil
    @line_color = 'black'
    @shadow_color = nil
    @font_size = 21
    @maximum_value = nil
    @minimum_value = nil
    @count = nil
    @increment = nil
    @format = nil
    @stroke_dash = nil
    @stroke_opacity = 1
    @skip_lines = nil
    @m_increment = nil
    @m_spread = 1
    @m_offset = 0
  end

end
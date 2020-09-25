# frozen_string_literal: true

##
# Original Author: David Stokar
#
#   This class performs the y coordinates conversion for the bar class.
#
#   There are three cases:
#
#   1. Bars all go from zero in positive direction
#   2. Bars all go from zero to negative direction
#   3. Bars either go from zero to positive or from zero to negative
#
# @private
class Gruff::BarConversion
  attr_writer :mode
  attr_writer :zero
  attr_writer :graph_top
  attr_writer :graph_height
  attr_writer :minimum_value
  attr_writer :spread

  def get_left_y_right_y_scaled(data_point)
    result = []

    case @mode
    when 1
      # minimum value >= 0 ( only positive values )
      result[0] = @graph_top + @graph_height * (1 - data_point) + 1
      result[1] = @graph_top + @graph_height - 1
    when 2
      # only negative values
      result[0] = @graph_top + 1
      result[1] = @graph_top + @graph_height * (1 - data_point) - 1
    when 3
      # positive and negative values
      val = data_point - @minimum_value / @spread
      result[0] = @graph_top + @graph_height * (1 - (val - @zero)) + 1
      result[1] = @graph_top + @graph_height * (1 - @zero) - 1
    else
      result[0] = 0.0
      result[1] = 0.0
    end

    result
  end
end

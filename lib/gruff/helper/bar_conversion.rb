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
  def initialize(top:, bottom:, minimum_value:, maximum_value:, spread:)
    @graph_top = top
    @graph_height = bottom - top
    @spread = spread
    @minimum_value = minimum_value
    @maximum_value = maximum_value

    if minimum_value >= 0
      # all bars go from zero to positive
      @mode = 1
    elsif maximum_value <= 0
      # all bars go from 0 to negative
      @mode = 2
    else
      # bars either go from zero to negative or to positive
      @mode = 3
      @zero = -minimum_value / @spread
    end
  end

  def get_top_bottom_scaled(data_point)
    result = []

    case @mode
    when 1
      # minimum value >= 0 ( only positive values )
      result[0] = @graph_top + (@graph_height * (1 - data_point))
      result[1] = @graph_top + @graph_height
    when 2
      # only negative values
      result[0] = @graph_top
      result[1] = @graph_top + (@graph_height * (1 - data_point))
    when 3
      # positive and negative values
      val = data_point - (@minimum_value / @spread)
      result[0] = @graph_top + (@graph_height * (1 - (val - @zero)))
      result[1] = @graph_top + (@graph_height * (1 - @zero))
    end

    result
  end
end

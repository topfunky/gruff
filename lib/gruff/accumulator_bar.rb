require File.dirname(__FILE__) + '/base'

##
# A special bar graph that shows a single dataset as a set of
# stacked bars. The bottom bar shows the running total and 
# the top bar shows the new value being added to the array.

class Gruff::AccumulatorBar < Gruff::StackedBar

  def draw
    raise(Gruff::IncorrectNumberOfDatasetsException) unless @data.length == 1
    
    accumulator_array = []
    index = 0

    increment_array = @data.first[DATA_VALUES_INDEX].inject([]) {|memo, value| 
        memo << ((index > 0) ? (value + memo.max) : value)
        accumulator_array << memo[index] - value
        index += 1
        memo
      }
    data "Accumulator", accumulator_array
    
    super
  end

end

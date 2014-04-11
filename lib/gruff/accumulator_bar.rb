require File.dirname(__FILE__) + '/base'

##
# A special bar graph that shows a single dataset as a set of
# stacked bars. The bottom bar shows the running total and 
# the top bar shows the new value being added to the array.

class Gruff::AccumulatorBar < Gruff::StackedBar
  attr_accessor :accumulator_label

  def initialize(*)
    super
    @accumulator_label = 'Accumulator'
  end

  def draw
    raise(Gruff::IncorrectNumberOfDatasetsException) unless @data.length == 1

    accum_array = @data.first[DATA_VALUES_INDEX][0..-2].inject([0]) { |a, v| a << a.last + v}
    data @accumulator_label, accum_array
    set_colors
    @data.reverse!
    super
  end
end

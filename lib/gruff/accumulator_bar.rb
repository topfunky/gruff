require File.dirname(__FILE__) + '/base'

##
# A special bar graph that shows a single dataset as a set of
# stacked bars. The bottom bar shows the running total and 
# the top bar shows the new value being added to the array.
#
# An optional "Carry Forward" value can be set which will initialize the
# accumulator to a non-zero value. If a label is provided for the carry_forward,
# then a band of data (mostly zero's) will be plugged in as the middle data set
# and there will be an actual visible representation of the carry-forward.
# Without a label, the graph will show the accumulator starting at a non-zero point.

class Gruff::AccumulatorBar < Gruff::StackedBar
  attr_accessor :accumulator_label
  attr_accessor :carry_forward
  attr_accessor :carry_forward_label

  def initialize(*)
    super
    @accumulator_label = 'Accumulator'
  end

  def draw
    raise(Gruff::IncorrectNumberOfDatasetsException) unless @data.length == 1

    accum_array = @data.first[DATA_VALUES_INDEX][0..-2].inject([carry_forward.nil? ? 0 : carry_forward]) { |a, v| a << a.last + v}

    # Insert a data row for the carry-forward if explicitly given a label for it (and a value!)
    if ! carry_forward.nil? && ! carry_forward_label.nil?
      carry_array = Array.new(accum_array.length, 0)
      # Since we'll be representing the carry-forward,
      # remove it's value from the first bar of the accumulator.
      accum_array[0] -= carry_forward
      carry_array[0] += carry_forward
    end

    data accumulator_label, accum_array
    data carry_forward_label, carry_array if ! carry_forward.nil? && ! carry_forward_label.nil?

    set_colors

    # Swap in a way that's friendly to the optional carry-forward row.
    accum_array = @data[-1]
    @data[-1] = @data[0]
    @data[0] = accum_array

    super
  end
end

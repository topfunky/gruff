# frozen_string_literal: true

# rbs_inline: enabled

#
# Gruff::AccumulatorBar is a special bar graph that shows a
# single dataset as a set of stacked bars.
# The bottom bar shows the running total and the top bar shows
# the new value being added to the array.
#
# Here's how to set up a Gruff::AccumulatorBar.
#
#   g = Gruff::AccumulatorBar.new
#   g.title = 'Your Savings'
#   g.data 'First', [1, 1, 1]
#   g.write('accumulator_bar.png')
#
class Gruff::AccumulatorBar < Gruff::StackedBar
private

  def setup_data
    raise(Gruff::IncorrectNumberOfDatasetsException) unless store.length == 1

    accum_array = store.data.first.points[0..-2].reduce([0]) { |a, v| a << (a.last + v.to_f) } # steep:ignore
    data 'Accumulator', accum_array
    set_colors
    store.reverse!
    super
  end
end

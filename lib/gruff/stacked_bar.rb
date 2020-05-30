# frozen_string_literal: true

require 'gruff/base'
require 'gruff/helper/stacked_mixin'
require 'gruff/helper/bar_value_label_mixin'

#
# Here's how to set up a Gruff::StackedBar.
#
#   g = Gruff::StackedBar.new
#   g.title = 'StackedBar Graph'
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('stacked_bar.png')
#
class Gruff::StackedBar < Gruff::Base
  include StackedMixin
  include BarValueLabelMixin

  # Spacing factor applied between bars.
  attr_accessor :bar_spacing

  # Number of pixels between bar segments.
  attr_accessor :segment_spacing

  # Set the number output format for labels using sprintf.
  # Default is +"%.2f"+.
  attr_accessor :label_formatting

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_accessor :show_labels_for_bar_values

  def initialize_ivars
    super
    @label_formatting = nil
    @show_labels_for_bar_values = false
  end
  private :initialize_ivars

  # Draws a bar graph, but multiple sets are stacked on top of each other.
  def draw
    calculate_maximum_by_stack
    super
    return unless data_given?

    # Setup spacing.
    #
    # Columns sit stacked.
    @bar_spacing ||= 0.9
    @segment_spacing ||= 2

    bar_width = @graph_width / column_count.to_f
    padding = (bar_width * (1 - @bar_spacing)) / 2

    height = Array.new(column_count, 0)
    bar_value_label = BarValueLabel.new(column_count, bar_width)

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        next if data_point == 0

        # Use incremented x and scaled y
        left_x = @graph_left + (bar_width * point_index) + padding
        left_y = @graph_top + (@graph_height -
                               data_point * @graph_height -
                               height[point_index]) + @segment_spacing
        right_x = left_x + bar_width * @bar_spacing
        right_y = @graph_top + @graph_height - height[point_index]

        # update the total height of the current stacked bar
        height[point_index] += (data_point * @graph_height)

        rect_renderer = Gruff::Renderer::Rectangle.new(color: data_row.color)
        rect_renderer.render(left_x, left_y, right_x, right_y)

        # Calculate center based on bar_width and current row
        label_center = left_x + bar_width * @bar_spacing / 2.0
        draw_label(label_center, point_index)

        bar_value_label.coordinates[point_index] = [left_x, left_y, right_x, right_y]
        bar_value_label.values[point_index] += store.data[row_index].points[point_index]
      end
    end

    if @show_labels_for_bar_values
      bar_value_label.prepare_rendering(@label_formatting) do |x, y, text|
        draw_value_label(x, y, text, true)
      end
    end

    Gruff::Renderer.finish
  end
end

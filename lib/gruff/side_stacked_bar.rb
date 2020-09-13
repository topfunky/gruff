# frozen_string_literal: true

require 'gruff/side_bar'
require 'gruff/helper/stacked_mixin'

#
# New gruff graph type added to enable sideways stacking bar charts
# (basically looks like a x/y flip of a standard stacking bar chart)
#
# Here's how to set up a Gruff::SideStackedBar.
#
#   g = Gruff::SideStackedBar.new
#   g.title = 'SideStackedBar Graph'
#   g.labels = {
#     0 => '5/6',
#     1 => '5/15',
#     2 => '5/24',
#     3 => '5/30',
#   }
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('side_stacked_bar.png')
#
class Gruff::SideStackedBar < Gruff::SideBar
  include StackedMixin
  include BarValueLabelMixin

  # Spacing factor applied between bars.
  attr_writer :bar_spacing

  # Number of pixels between bar segments.
  attr_writer :segment_spacing

  # Set the number output format for labels using sprintf.
  # Default is +"%.2f"+.
  attr_writer :label_formatting

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_writer :show_labels_for_bar_values

  # Prevent drawing of column labels left of a side stacked bar graph.  Default is +false+.
  attr_writer :hide_labels

  def initialize_ivars
    super
    @bar_spacing = 0.9
    @segment_spacing = 2.0
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
  end
  private :initialize_ivars

  def draw
    @has_left_labels = true
    calculate_maximum_by_stack
    super
  end

protected

  def hide_labels?
    @hide_labels
  end

  def hide_left_label_area?
    hide_labels?
  end

  def hide_bottom_label_area?
    @hide_line_markers
  end

private

  def draw_bars
    # Setup spacing.
    #
    # Columns sit stacked.
    bar_width = @graph_height / column_count.to_f
    height = Array.new(column_count, 0)
    length = Array.new(column_count, @graph_left)
    padding = (bar_width * (1 - @bar_spacing)) / 2
    bar_value_label = BarValueLabel.new(column_count, bar_width)

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        ## using the original calcs from the stacked bar chart to get the difference between
        ## part of the bart chart we wish to stack.
        temp1 = @graph_left + (@graph_width -
                                  data_point * @graph_width -
                                  height[point_index]) + 1
        temp2 = @graph_left + @graph_width - height[point_index] - 1
        difference = temp2 - temp1

        left_x = length[point_index]
        left_y = @graph_top + (bar_width * point_index) + padding
        right_x = left_x + difference - @segment_spacing
        right_y = left_y + bar_width * @bar_spacing
        length[point_index] += difference
        height[point_index] += (data_point * @graph_width - 2)

        bar_value_label.coordinates[point_index] = [left_x, left_y, right_x, right_y]
        bar_value_label.values[point_index] += store.data[row_index].points[point_index]

        # if a data point is 0 it can result in weird really thing lines
        # that shouldn't even be there being drawn on top of the existing
        # bar - this is bad
        if data_point != 0
          rect_renderer = Gruff::Renderer::Rectangle.new(color: data_row.color)
          rect_renderer.render(left_x, left_y, right_x, right_y)
          # Calculate center based on bar_width and current row
        end
        # we still need to draw the labels
        # Calculate center based on bar_width and current row
        label_center = left_y + bar_width / 2
        draw_label(label_center, point_index)
      end
    end

    if @show_labels_for_bar_values
      bar_value_label.prepare_sidebar_rendering(@label_formatting) do |x, y, text|
        draw_value_label(x, y, text, true)
      end
    end

    Gruff::Renderer.finish
  end
end

# frozen_string_literal: true

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

  # Spacing factor applied between bars.
  attr_writer :bar_spacing

  # Number of pixels between bar segments.
  attr_writer :segment_spacing

  # Set the number output format string or lambda.
  # Default is +"%.2f"+.
  attr_writer :label_formatting

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_writer :show_labels_for_bar_values

  # Prevent drawing of column labels below a stacked bar graph.  Default is +false+.
  attr_writer :hide_labels

private

  def initialize_attributes
    super
    @bar_spacing = 0.9
    @segment_spacing = 2
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
    @minimum_value = 0.0
  end

  def setup_data
    calculate_maximum_by_stack
    super
  end

  def setup_graph_measurements
    super
    return if @hide_line_markers

    if @show_labels_for_bar_values
      proc_text_metrics = ->(text) { text_metrics(@marker_font, text) }

      if maximum_value >= 0
        _, metrics = Gruff::BarValueLabel.metrics(maximum_value, @label_formatting, proc_text_metrics)
        @graph_top += metrics.height
      end

      @graph_height = @graph_bottom - @graph_top
    end
  end

  # Draws a bar graph, but multiple sets are stacked on top of each other.
  def draw_graph
    # Setup spacing.
    #
    # Columns sit stacked.
    bar_width = @graph_width / column_count.to_f
    padding = (bar_width * (1 - @bar_spacing)) / 2

    height = Array.new(column_count, 0)
    length = Array.new(column_count, @graph_bottom)
    stack_bar_value_labels = Gruff::BarValueLabel::StackedBar.new

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        temp1 = @graph_top + (@graph_height - (data_point * @graph_height) - height[point_index])
        temp2 = @graph_top + @graph_height - height[point_index]
        difference = temp2 - temp1
        difference = 0 if difference < 0

        # Use incremented x and scaled y
        left_x = @graph_left + (bar_width * point_index) + padding
        left_y = length[point_index] - difference
        right_x = left_x + (bar_width * @bar_spacing)
        right_y = length[point_index]
        right_y -= @segment_spacing if row_index != store.columns - 1

        # update the total height of the current stacked bar
        length[point_index] -= difference
        height[point_index] += (data_point * @graph_height)

        rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: data_row.color)
        rect_renderer.render(left_x, left_y, right_x, right_y)

        # Calculate center based on bar_width and current row
        label_center = left_x + (bar_width * @bar_spacing / 2.0)
        draw_label(label_center, point_index)

        bar_value_label = Gruff::BarValueLabel::Bar.new([left_x, left_y, right_x, right_y], store.data[row_index].points[point_index])
        stack_bar_value_labels.add(bar_value_label, point_index)
      end
    end

    if @show_labels_for_bar_values
      proc_text_metrics = ->(text) { text_metrics(@marker_font, text) }
      stack_bar_value_labels.prepare_rendering(@label_formatting, proc_text_metrics) do |x, y, text, _text_width, text_height|
        draw_value_label(bar_width * @bar_spacing, text_height, x, y, text)
      end
    end
  end

  def hide_labels?
    @hide_labels
  end

  def hide_left_label_area?
    @hide_line_markers && @y_axis_label.nil?
  end

  def hide_bottom_label_area?
    hide_labels? && @x_axis_label.nil? && @legend_at_bottom == false
  end
end

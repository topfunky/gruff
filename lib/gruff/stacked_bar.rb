# frozen_string_literal: true

# rbs_inline: enabled

require_relative 'helper/stacked_mixin'

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
  include Gruff::Base::StackedMixin

  # Spacing factor applied between bars.
  attr_writer :bar_spacing #: Float | Integer

  # Number of pixels between bar segments.
  attr_writer :segment_spacing #: Float | Integer

  # Set the number output format string or lambda.
  # Default is +"%.2f"+.
  attr_writer :label_formatting #: nil | String | Proc

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_writer :show_labels_for_bar_values #: bool

  # Prevent drawing of column labels below a stacked bar graph.  Default is +false+.
  attr_writer :hide_labels #: bool

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

  def setup_drawing
    # Labels will be centered over the left of the bar if
    # there are more labels than columns. This is basically the same
    # as where it would be for a line graph.
    @center_labels_over_point = (@labels.keys.length > column_count)

    super
  end

  def setup_data
    calculate_maximum_by_stack
    super
  end

  def setup_graph_measurements
    super
    return if @hide_line_markers

    if @show_labels_for_bar_values
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
    bar_width = @graph_width / column_count
    padding = (bar_width * (1.0 - @bar_spacing)) / 2.0

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_top, bottom: @graph_bottom,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    normalized_stacked_bars.each_with_index do |stacked_bars, stacked_index|
      total = 0.0
      left_x = @graph_left + (bar_width * stacked_index) + padding
      right_x = left_x + (bar_width * @bar_spacing)

      top_y = 0.0
      stacked_bars.each do |bar|
        next if bar.point.nil? || bar.point == 0

        bottom_y, = conversion.get_top_bottom_scaled(total)
        bottom_y -= @segment_spacing
        top_y, = conversion.get_top_bottom_scaled(total + bar.point)

        rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: bar.color)
        rect_renderer.render(left_x, bottom_y, right_x, top_y)

        total += bar.point
      end

      label_center = left_x + (bar_width * @bar_spacing / 2.0)
      draw_label(label_center, stacked_index)

      if @show_labels_for_bar_values
        bar_value_label = Gruff::BarValueLabel::Bar.new([left_x, top_y, right_x, @graph_bottom], stacked_bars.sum(&:value))
        bar_value_label.prepare_rendering(@label_formatting, proc_text_metrics) do |x, y, text, _text_width, text_height|
          draw_value_label(bar_width * @bar_spacing, text_height, x, y, text)
        end
      end
    end
  end

  # @rbs return: bool
  def hide_labels?
    @hide_labels
  end

  # @rbs return: bool
  def hide_left_label_area?
    @hide_line_markers && @y_axis_label.nil?
  end

  # @rbs return: bool
  def hide_bottom_label_area?
    hide_labels? && @x_axis_label.nil? && @legend_at_bottom == false
  end

  # @rbs return: Proc
  def proc_text_metrics
    ->(text) { text_metrics(@marker_font, text) }
  end
end

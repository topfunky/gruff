# frozen_string_literal: true

# rbs_inline: enabled

require_relative 'helper/bar_mixin'

#
# Gruff::Bar provide a bar graph that presents categorical data
# with rectangular bars.
#
# Here's how to set up a Gruff::Bar.
#
#   g = Gruff::Bar.new
#   g.title = 'Bar Graph With Manual Colors'
#   g.spacing_factor = 0.1
#   g.group_spacing = 20
#   g.data :Art, [0, 5, 8, 15], '#990000'
#   g.data :Philosophy, [10, 3, 2, 8], '#009900'
#   g.data :Science, [2, 15, 8, 11], '#990099'
#   g.write('bar.png')
#
class Gruff::Bar < Gruff::Base
  include Gruff::Base::BarMixin

  # Spacing factor applied between bars.
  attr_writer :bar_spacing #: Float | Integer

  # Spacing factor applied between a group of bars belonging to the same label.
  attr_writer :group_spacing #: Float | Integer

  # Set the number output format string or lambda.
  # Default is +"%.2f"+.
  attr_writer :label_formatting #: nil | String | Proc

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_writer :show_labels_for_bar_values #: bool

  # Prevent drawing of column labels below a bar graph.  Default is +false+.
  attr_writer :hide_labels #: bool

  # Value to avoid completely overwriting the coordinate axis
  AXIS_MARGIN = 0.5
  private_constant :AXIS_MARGIN

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is +0.9+.
  #
  # @rbs space_percent: Float | Integer
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' if (space_percent < 0) || (space_percent > 1)

    @spacing_factor = (1.0 - space_percent)
  end

private

  def initialize_attributes
    super
    @spacing_factor = 0.9
    @group_spacing = 10
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
  end

  def setup_drawing
    # Labels will be centered over the left of the bar if
    # there are more labels than columns. This is basically the same
    # as where it would be for a line graph.
    @center_labels_over_point = (@labels.keys.length > column_count)

    super
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

  def draw_graph
    # Setup spacing.
    #
    # Columns sit side-by-side.
    @bar_spacing ||= @spacing_factor # space between the bars

    bar_width = (@graph_width - calculate_spacing) / (column_count * store.length)
    padding = (bar_width * (1.0 - @bar_spacing)) / 2.0

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_top, bottom: @graph_bottom,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    group_left_x = @graph_left

    normalized_group_bars.each_with_index do |group_bars, group_index|
      right_x = 0.0
      group_bars.each_with_index do |bar, index|
        left_x = group_left_x + (bar_width * index) + padding
        right_x = left_x + (bar_width * @bar_spacing)

        top_y, bottom_y = conversion.get_top_bottom_scaled(bar.point)
        if top_y != bottom_y
          rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: bar.color)
          rect_renderer.render(left_x, bottom_y - AXIS_MARGIN, right_x, top_y)
        end

        if @show_labels_for_bar_values && bar.value
          bar_value_label = Gruff::BarValueLabel::Bar.new([left_x, top_y, right_x, bottom_y], bar.value)
          bar_value_label.prepare_rendering(@label_formatting, proc_text_metrics) do |x, y, text, _text_width, text_height|
            draw_value_label(bar_width * @bar_spacing, text_height, x, y, text)
          end
        end
      end

      label_center = group_left_x + ((right_x - group_left_x) / 2.0)
      draw_label(label_center, group_index)

      group_left_x = right_x + padding + @group_spacing
    end

    # Draw the last label if requested
    draw_label(@graph_right, column_count, Magick::NorthWestGravity) if @center_labels_over_point
  end

  # @rbs return: Float | Integer
  def calculate_spacing
    @group_spacing * (column_count - 1)
  end

  # @rbs return: Proc
  def proc_text_metrics
    ->(text) { text_metrics(@marker_font, text) }
  end
end

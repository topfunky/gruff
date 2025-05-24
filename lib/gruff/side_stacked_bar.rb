# frozen_string_literal: true

# rbs_inline: enabled

require_relative 'helper/stacked_mixin'

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

  # Prevent drawing of column labels left of a side stacked bar graph.  Default is +false+.
  attr_writer :hide_labels #: bool

  # @rbs target_width: (String | Float | Integer)
  # @rbs return: void
  def initialize(target_width = DEFAULT_TARGET_WIDTH)
    super
    @has_left_labels = true
  end

private

  def initialize_attributes
    super
    @bar_spacing = 0.9
    @segment_spacing = 2.0
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
    @minimum_value = 0.0
  end

  def setup_data
    calculate_maximum_by_stack
    super
  end

  def draw_graph
    # Setup spacing.
    #
    # Columns sit stacked.
    bar_width = @graph_height / column_count
    padding = (bar_width * (1.0 - @bar_spacing)) / 2

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_right, bottom: @graph_left,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    proc_text_metrics = ->(text) { text_metrics(@marker_font, text) }

    normalized_stacked_bars.each_with_index do |stacked_bars, stacked_index|
      total = 0.0
      left_y = @graph_top + (bar_width * stacked_index) + padding
      right_y = left_y + (bar_width * @bar_spacing)

      top_x = 0.0
      stacked_bars.each do |bar|
        next if bar.point.nil? || bar.point == 0

        bottom_x, = conversion.get_top_bottom_scaled(total)
        bottom_x += @segment_spacing
        top_x, = conversion.get_top_bottom_scaled(total + bar.point)

        rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: bar.color)
        rect_renderer.render(bottom_x, left_y, top_x, right_y)

        total += bar.point
      end

      label_center = left_y + (bar_width / 2.0)
      draw_label(label_center, stacked_index)

      if @show_labels_for_bar_values
        bar_value_label = Gruff::BarValueLabel::SideBar.new([@graph_left, left_y, top_x, right_y], stacked_bars.sum(&:value))
        bar_value_label.prepare_rendering(@label_formatting, proc_text_metrics) do |x, y, text, text_width, _text_height|
          draw_value_label(text_width, bar_width * @bar_spacing, x, y, text)
        end
      end
    end
  end
end

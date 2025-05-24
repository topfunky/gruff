# frozen_string_literal: true

# rbs_inline: enabled

require_relative 'helper/bar_mixin'

# Graph with individual horizontal bars instead of vertical bars.
#
# Here's how to set up a Gruff::SideBar.
#
#   g = Gruff::SideBar.new
#   g.title = 'SideBar Graph'
#   g.labels = {
#     0 => '5/6',
#     1 => '5/15',
#     2 => '5/24',
#     3 => '5/30',
#   }
#   g.group_spacing = 20
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('sidebar.png')
#
class Gruff::SideBar < Gruff::Base
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

  # Prevent drawing of column labels left of a side bar graph.  Default is +false+.
  attr_writer :hide_labels #: bool

  # Value to avoid completely overwriting the coordinate axis
  AXIS_MARGIN = 0.5
  private_constant :AXIS_MARGIN

  # @rbs target_width: (String | Float | Integer)
  # @rbs return: void
  def initialize(target_width = DEFAULT_TARGET_WIDTH)
    super
    @has_left_labels = true
  end

  # With Side Bars use the data label for the marker value to the left of the bar.
  # @deprecated
  def use_data_label=(_value)
    warn '#use_data_label is deprecated. It is no longer effective.'
  end

private

  def initialize_attributes
    super
    @bar_spacing = 0.9
    @group_spacing = 10
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
  end

  # @rbs return: bool
  def hide_labels?
    @hide_labels
  end

  # @rbs return: bool
  def hide_left_label_area?
    hide_labels? && @y_axis_label.nil?
  end

  # @rbs return: bool
  def hide_bottom_label_area?
    @hide_line_markers && @x_axis_label.nil? && @legend_at_bottom == false
  end

  def setup_graph_measurements
    super
    return if @hide_line_markers

    if @show_labels_for_bar_values
      if maximum_value >= 0
        _, metrics = Gruff::BarValueLabel.metrics(maximum_value, @label_formatting, proc_text_metrics)
        @graph_right -= metrics.width
      end

      if minimum_value < 0
        _, metrics = Gruff::BarValueLabel.metrics(minimum_value, @label_formatting, proc_text_metrics)
        width = metrics.width + @label_margin
        @graph_left += width - @graph_left if width > @graph_left
      end

      @graph_width = @graph_right - @graph_left
    end
  end

  def draw_graph
    # Setup spacing.
    #
    bars_width = (@graph_height - calculate_spacing) / column_count
    bar_width = bars_width / store.length
    padding = (bar_width * (1.0 - @bar_spacing)) / 2

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_right, bottom: @graph_left,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    group_left_y = @graph_top

    normalized_group_bars.each_with_index do |group_bars, group_index|
      right_y = 0.0
      group_bars.each_with_index do |bar, index|
        left_y = group_left_y + (bar_width * index) + padding
        right_y = left_y + (bar_width * @bar_spacing)

        bottom_x, top_x = conversion.get_top_bottom_scaled(bar.point).sort #: [Float, Float]
        if bottom_x != top_x
          rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: bar.color)
          rect_renderer.render(bottom_x + AXIS_MARGIN, left_y, top_x, right_y)
        end

        if @show_labels_for_bar_values && bar.value
          bar_value_label = Gruff::BarValueLabel::SideBar.new([bottom_x, left_y, top_x, right_y], bar.value)
          bar_value_label.prepare_rendering(@label_formatting, proc_text_metrics) do |x, y, text, text_width, _text_height|
            draw_value_label(text_width, bar_width * @bar_spacing, x, y, text)
          end
        end
      end

      label_center = group_left_y + (bars_width / 2.0)
      draw_label(label_center, group_index)

      group_left_y = right_y + padding + @group_spacing
    end
  end

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers
    return if @hide_line_markers

    # Draw horizontal line markers and annotate with numbers
    number_of_lines = marker_count
    number_of_lines = 1 if number_of_lines == 0

    # TODO: Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
    increment = significant(@spread / number_of_lines)
    (0..number_of_lines).each do |index|
      line_diff = (@graph_right - @graph_left) / number_of_lines
      x = @graph_right - (line_diff * index) - 1
      draw_marker_vertical_line(x)

      unless @hide_line_numbers
        diff = index - number_of_lines
        marker_label = (BigDecimal(diff.abs.to_s) * BigDecimal(increment.to_s)) + BigDecimal(minimum_value.to_s)
        label = x_axis_label(marker_label, @increment)
        y = @graph_bottom + @label_margin + (labels_caps_height / 2.0)
        text_renderer = Gruff::Renderer::Text.new(renderer, label, font: @marker_font)
        text_renderer.add_to_render_queue(0, 0, x, y, Magick::CenterGravity)
      end
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index)
    draw_unique_label(index) do
      draw_label_at(@graph_left - @label_margin, 1.0, 0.0, y_offset, @labels[index], gravity: Magick::EastGravity)
    end
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

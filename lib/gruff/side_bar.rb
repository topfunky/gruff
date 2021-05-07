# frozen_string_literal: true

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
  using String::GruffCommify

  # Spacing factor applied between bars.
  attr_writer :bar_spacing

  # Spacing factor applied between a group of bars belonging to the same label.
  attr_writer :group_spacing

  # Set the number output format for labels using sprintf.
  # Default is +"%.2f"+.
  attr_writer :label_formatting

  # Output the values for the bars on a bar graph.
  # Default is +false+.
  attr_writer :show_labels_for_bar_values

  # Prevent drawing of column labels left of a side bar graph.  Default is +false+.
  attr_writer :hide_labels

  def initialize_ivars
    super
    @bar_spacing = 0.9
    @group_spacing = 10
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
  end
  private :initialize_ivars

  def draw
    @has_left_labels = true
    super

    return unless data_given?

    draw_bars
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

  # Value to avoid completely overwriting the coordinate axis
  AXIS_MARGIN = 0.5

  def draw_bars
    # Setup spacing.
    #
    bars_width = (@graph_height - calculate_spacing) / column_count.to_f
    bar_width = bars_width / store.length
    padding = (bar_width * (1 - @bar_spacing)) / 2

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_right, bottom: @graph_left,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    # if we're a side stacked bar then we don't need to draw ourself at all
    # because sometimes (due to different heights/min/max) you can actually
    # see both graphs and it looks like crap
    return if is_a?(Gruff::SideStackedBar)

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        group_spacing = @group_spacing * @scale * point_index

        left_y = @graph_top + (bars_width * point_index) + (bar_width * row_index) + padding + group_spacing
        right_y = left_y + bar_width * @bar_spacing

        left_x, right_x = conversion.get_top_bottom_scaled(data_point).sort

        rect_renderer = Gruff::Renderer::Rectangle.new(color: data_row.color)
        rect_renderer.render(left_x + AXIS_MARGIN, left_y, right_x + AXIS_MARGIN, right_y)

        # Calculate center based on bar_width and current row

        if @use_data_label
          label_center = left_y + bar_width / 2
          draw_label(label_center, row_index, store.norm_data[row_index].label)
        else
          label_center = left_y + bars_width / 2
          draw_label(label_center, point_index)
        end
        if @show_labels_for_bar_values
          raw_value = store.data[row_index].points[point_index]
          val = (@label_formatting || '%.2f') % raw_value
          x = raw_value >= 0 ? right_x + 40 : left_x - 40
          draw_value_label(x, right_y - bar_width / 2, val.commify, true)
        end
      end
    end
  end

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers
    return if @hide_line_markers

    # Draw horizontal line markers and annotate with numbers
    number_of_lines = marker_count
    number_of_lines = 1 if number_of_lines == 0

    # TODO: Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
    increment = significant(@spread.to_f / number_of_lines)
    (0..number_of_lines).each do |index|
      line_diff = (@graph_right - @graph_left) / number_of_lines
      x = @graph_right - (line_diff * index) - 1

      line_renderer = Gruff::Renderer::Line.new(color: @marker_color, shadow_color: @marker_shadow_color)
      line_renderer.render(x, @graph_bottom, x, @graph_top)

      unless @hide_line_numbers
        diff = index - number_of_lines
        marker_label = BigDecimal(diff.abs.to_s) * BigDecimal(increment.to_s) + BigDecimal(minimum_value.to_s)
        label = label(marker_label, @increment)
        text_renderer = Gruff::Renderer::Text.new(label, font: @font, size: @marker_font_size, color: @font_color)
        text_renderer.add_to_render_queue(0, 0, x, @graph_bottom + LABEL_MARGIN, Magick::CenterGravity)
      end
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index, label = nil)
    draw_unique_label(index) do
      lbl = @use_data_label ? label : @labels[index]

      text_renderer = Gruff::Renderer::Text.new(lbl, font: @font, size: @marker_font_size, color: @font_color)
      text_renderer.add_to_render_queue(@graph_left - LABEL_MARGIN, 1.0, 0.0, y_offset, Magick::EastGravity)
    end
  end

  def calculate_spacing
    @scale * @group_spacing * (column_count - 1)
  end
end

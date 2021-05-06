# frozen_string_literal: true

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

  # Prevent drawing of column labels below a bar graph.  Default is +false+.
  attr_writer :hide_labels

  def initialize_ivars
    super
    @spacing_factor = 0.9
    @group_spacing = 10
    @label_formatting = nil
    @show_labels_for_bar_values = false
    @hide_labels = false
  end
  private :initialize_ivars

  def draw
    # Labels will be centered over the left of the bar if
    # there are more labels than columns. This is basically the same
    # as where it would be for a line graph.
    @center_labels_over_point = (@labels.keys.length > column_count)

    super
    return unless data_given?

    draw_bars
  end

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is +0.9+.
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' unless (space_percent >= 0) && (space_percent <= 1)

    @spacing_factor = (1 - space_percent)
  end

protected

  def hide_labels?
    @hide_labels
  end

  def hide_left_label_area?
    @hide_line_markers
  end

  def hide_bottom_label_area?
    hide_labels?
  end

  # Value to avoid completely overwriting the coordinate axis
  AXIS_MARGIN = 0.5

  def draw_bars
    # Setup spacing.
    #
    # Columns sit side-by-side.
    @bar_spacing ||= @spacing_factor # space between the bars

    bar_width = (@graph_width - calculate_spacing) / (column_count * store.length).to_f
    padding = (bar_width * (1 - @bar_spacing)) / 2

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new
    conversion.graph_height = @graph_height
    conversion.graph_top = @graph_top

    # Set up the right mode [1,2,3] see BarConversion for further explanation
    if minimum_value >= 0
      # all bars go from zero to positive
      conversion.mode = 1
    elsif maximum_value <= 0
      # all bars go from 0 to negative
      conversion.mode = 2
    else
      # bars either go from zero to negative or to positive
      conversion.mode = 3
      conversion.spread = @spread
      conversion.minimum_value = minimum_value
      conversion.zero = -minimum_value / @spread
    end

    # iterate over all normalised data
    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        group_spacing = @group_spacing * @scale * point_index

        # Use incremented x and scaled y
        # x
        left_x = @graph_left + (bar_width * (row_index + point_index + ((store.length - 1) * point_index))) + padding + group_spacing
        right_x = left_x + bar_width * @bar_spacing
        # y
        left_y, right_y = conversion.get_left_y_right_y_scaled(data_point)

        # create new bar
        rect_renderer = Gruff::Renderer::Rectangle.new(color: data_row.color)
        rect_renderer.render(left_x, left_y - AXIS_MARGIN, right_x, right_y - AXIS_MARGIN)

        # Calculate center based on bar_width and current row
        label_center = @graph_left + group_spacing + (store.length * bar_width * point_index) + (store.length * bar_width / 2.0)

        # Subtract half a bar width to center left if requested
        draw_label(label_center, point_index)
        if @show_labels_for_bar_values
          raw_value = store.data[row_index].points[point_index]
          val = (@label_formatting || '%.2f') % raw_value
          y = raw_value >= 0 ? left_y - 30 : left_y + 12
          draw_value_label(left_x + (right_x - left_x) / 2, y, val.commify, true)
        end
      end
    end

    # Draw the last label if requested
    draw_label(@graph_right, column_count, Magick::NorthWestGravity) if @center_labels_over_point
  end

  def calculate_spacing
    @scale * @group_spacing * (column_count - 1)
  end
end

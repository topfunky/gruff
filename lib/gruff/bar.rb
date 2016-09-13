require File.dirname(__FILE__) + '/base'
require File.dirname(__FILE__) + '/bar_conversion'

class Gruff::Bar < Gruff::Base

  # Spacing factor applied between bars
  attr_accessor :bar_spacing

  def initialize(*args)
    super
    @spacing_factor = 0.9
  end

  def draw
    super
    return unless @has_data

    setup
    draw_labels_below
    draw_bars
  end

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is 0.9.
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' unless (space_percent >= 0 and space_percent <= 1)
    @spacing_factor = (1 - space_percent)
  end

protected

  def setup
    # Labels will be centered over the left of the bar if
    # there are more labels than columns. This is basically the same
    # as where it would be for a line graph.
    @center_labels_over_point = @labels.keys.length > @column_count
    # Setup spacing.
    #
    # Columns sit side-by-side.
    @bar_spacing ||= @spacing_factor # space between the bars
    @bar_width = @graph_width / (@column_count * @data.length).to_f
    @padding = (@bar_width * (1 - @bar_spacing)) / 2

    @d = @d.stroke_opacity 0.0

    # Setup the BarConversion Object
    @conversion = Gruff::BarConversion.new()
    @conversion.graph_height = @graph_height
    @conversion.graph_top = @graph_top

    # Set up the right mode [1,2,3] see BarConversion for further explanation
    if @minimum_value >= 0 then
      # all bars go from zero to positiv
      @conversion.mode = 1
    else
      # all bars go from 0 to negativ
      if @maximum_value <= 0 then
        @conversion.mode = 2
      else
        # bars either go from zero to negativ or to positiv
        @conversion.mode = 3
        @conversion.spread = @spread
        @conversion.minimum_value = @minimum_value
        @conversion.zero = -@minimum_value/@spread
      end
    end
  end

  def draw_bars
    @norm_data.each_with_index do |data_row, row_index|
      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|

        left = left(row_index, point_index)
        right = right(left)
        bottom = bottom(data_point)
        top = top(data_point)

        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.rectangle(left, bottom, right, top)

        if @show_labels_for_bar_values
          val = (@label_formatting || '%.2f') % @norm_data[row_index][3][point_index]
          draw_value_label(left + (right - left)/2, bottom - 30, val.commify, true)
        end
      end
    end
    @d.draw(@base_image)
  end

  def left(row_index, point_index)
    @graph_left + (@bar_width * (row_index + point_index + ((@data.length - 1) * point_index))) + @padding
  end

  def right(left)
    left + @bar_width * @bar_spacing
  end

  def top(data_point)
    conv = []
    @conversion.get_left_y_right_y_scaled(data_point, conv)
    conv[1]
  end

  def bottom(data_point)
    conv = []
    @conversion.get_left_y_right_y_scaled(data_point, conv)
    conv[0]
  end

  def draw_labels_below
    @norm_data.each_with_index do |data_row, row_index|
      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|

        # Calculate center based on bar_width and current row
        label_center = @graph_left +
                      (@data.length * @bar_width * point_index) +
                      (@data.length * @bar_width / 2.0)

        # Subtract half a bar width to center left if requested
        draw_label(label_center - (@center_labels_over_point ? @bar_width / 2.0 : 0.0), point_index)
      end
    end

    # Draw the last label if requested
    draw_label(@graph_right, @column_count) if @center_labels_over_point
  end

end

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
    # Labels will be centered over the left of the bar if
    # there are more labels than columns. This is basically the same 
    # as where it would be for a line graph.
    @center_labels_over_point = (@labels.keys.length > @column_count ? true : false)
    
    super
    return unless @has_data

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

  def draw_bars
    # Setup spacing.
    #
    # Columns sit side-by-side.
    @bar_spacing ||= @spacing_factor # space between the bars
    @bar_width = @graph_width / (@column_count * @data.length).to_f
    padding = (@bar_width * (1 - @bar_spacing)) / 2

    @d = @d.stroke_opacity 0.0

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new()
    conversion.graph_height = @graph_height
    conversion.graph_top = @graph_top

    # Set up the right mode [1,2,3] see BarConversion for further explanation
    if @minimum_value >= 0 then
      # all bars go from zero to positiv
      conversion.mode = 1
    else
      # all bars go from 0 to negativ
      if @maximum_value <= 0 then
        conversion.mode = 2
      else
        # bars either go from zero to negativ or to positiv
        conversion.mode = 3
        conversion.spread = @spread
        conversion.minimum_value = @minimum_value
        conversion.zero = -@minimum_value/@spread
      end
    end

    # iterate over all normalised data
    @norm_data.each_with_index do |data_row, row_index|

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
        # Use incremented x and scaled y
        # x
        left_x = @graph_left + (@bar_width * (row_index + point_index + ((@data.length - 1) * point_index))) + padding
        right_x = left_x + @bar_width * @bar_spacing
        # y
        conv = []
        conversion.get_left_y_right_y_scaled( data_point, conv )

        # create new bar
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.rectangle(left_x, conv[0], right_x, conv[1])

        # Calculate center based on bar_width and current row
        label_center = @graph_left + 
                      (@data.length * @bar_width * point_index) + 
                      (@data.length * @bar_width / 2.0)

        # Subtract half a bar width to center left if requested
        draw_label(label_center - (@center_labels_over_point ? @bar_width / 2.0 : 0.0), point_index)
        if @show_labels_for_bar_values
          val = (@label_formatting || '%.2f') % @norm_data[row_index][3][point_index]
          draw_value_label(left_x + (right_x - left_x)/2, conv[0]-30, val.commify, true)
        end
      end

    end

    # Draw the last label if requested
    draw_label(@graph_right, @column_count) if @center_labels_over_point

    @d.draw(@base_image)
  end

end

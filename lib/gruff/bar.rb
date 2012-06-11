require File.dirname(__FILE__) + '/base'
require File.dirname(__FILE__) + '/bar_conversion'

class Gruff::Bar < Gruff::Base

  # Spacing factor applied between bars
  attr_accessor :bar_spacing
  
  def draw
    # Labels will be centered over the left of the bars if
    # there are more labels than columns. This is basically the same 
    # as where it would be for a line graph.
    @center_labels_over_point = (@labels.keys.length > @column_count ? true : false)
    
    super
    return unless @has_data

    draw_bars
  end

protected

  def draw_bars
    # Setup spacing.
    #
    # Columns sit side-by-side.
    @bar_spacing ||= 0.9 # space between the bars
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
        conversion.getLeftYRightYscaled( data_point, conv )

        # create new bar
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.rectangle(left_x, conv[0], right_x, conv[1])

        # Calculate center based on bar_width and current row
        # If center_labels_over_point is true, center the label over the left
        # of all bars for this data point. (similar to a line graph)
        # Otherwise, center it over the middle.
        label_center = @graph_left + 
                      (@data.length * @bar_width * point_index) + 
                      (@center_labels_over_point ? 0.0 : @data.length * @bar_width / 2.0)
        draw_label(label_center, point_index)
      end

    end

    # Draw the last label if requested
    draw_label(@graph_right, @column_count) if @center_labels_over_point

    @d.draw(@base_image)
  end

end

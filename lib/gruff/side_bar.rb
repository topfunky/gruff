require File.dirname(__FILE__) + '/base'

##
# Graph with individual horizontal bars instead of vertical bars.

class Gruff::SideBar < Gruff::Base

  # Spacing factor applied between bars
  attr_accessor :bar_spacing

  def draw
    @has_left_labels = true
    super

    return unless @has_data
    draw_bars
  end

  protected

  def draw_bars
    # Setup spacing.
    #
    @bar_spacing ||= 0.9

    @bars_width = @graph_height / @column_count.to_f
    @bar_width = @bars_width / @norm_data.size
    @d = @d.stroke_opacity 0.0
    height = Array.new(@column_count, 0)
    length = Array.new(@column_count, @graph_left)
    padding = (@bar_width * (1 - @bar_spacing)) / 2

    # if we're a side stacked bar then we don't need to draw ourself at all
    # because sometimes (due to different heights/min/max) you can actually
    # see both graphs and it looks like crap
    return if self.is_a?(Gruff::SideStackedBar)

    @norm_data.each_with_index do |data_row, row_index|
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|

        # Using the original calcs from the stacked bar chart
        # to get the difference between
        # part of the bart chart we wish to stack.
        temp1 = @graph_left + (@graph_width - data_point * @graph_width - height[point_index])
        temp2 = @graph_left + @graph_width - height[point_index]
        difference = temp2 - temp1

        left_x = length[point_index] - 1
        left_y = @graph_top + (@bars_width * point_index) + (@bar_width * row_index) + padding
        right_x = left_x + difference
        right_y = left_y + @bar_width * @bar_spacing

        height[point_index] += (data_point * @graph_width)

        @d = @d.rectangle(left_x, left_y, right_x, right_y)

        # Calculate center based on bar_width and current row

        if @use_data_label
          label_center = @graph_top + (@bar_width * (row_index+point_index) + @bar_width / 2)
          draw_label(label_center, row_index, @norm_data[row_index][DATA_LABEL_INDEX])
        else
          label_center = @graph_top + (@bars_width * point_index + @bars_width / 2)
          draw_label(label_center, point_index)
        end
        if @show_labels_for_bar_values
          val = (@label_formatting || '%.2f') % @norm_data[row_index][3][point_index]
          draw_value_label(right_x+40, (@graph_top + (((row_index+point_index+1) * @bar_width) - (@bar_width / 2)))-12, val.commify, true)
        end
      end
    end

    @d.draw(@base_image)
  end

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers

    return if @hide_line_markers

    @d = @d.stroke_antialias false

    # Draw horizontal line markers and annotate with numbers
    @d = @d.stroke(@marker_color)
    @d = @d.stroke_width 1

    # TODO Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
    if @x_axis_increment.nil?
      # Try to use a number of horizontal lines that will come out even.
      #
      # TODO Do the same for larger numbers...100, 75, 50, 25
      if @marker_count.nil?
        (3..7).each do |lines|
          if @spread % lines == 0.0
            @marker_count = lines
            break
          end
        end
        @marker_count ||= 5
      end

      #Don't do any rounding here
      @increment = (@spread > 0 && @marker_count > 0) ? @spread / @marker_count : 1
    else
      # TODO Make this work for negative values
      @marker_count = (@spread / @x_axis_increment).to_i
      @increment = @x_axis_increment
    end
    @increment_scaled = @graph_width.to_f / (@spread / @increment)

    (0..@marker_count).each do |index|

      #Instead of calulating the position and trying to fit the label to that position, generate the label first and work
      #backwards to find the proper location for the marker based on the label's number. The reason we do it this way
      #is so that we can account for the behaviour of the label() function (defined in base.rb) that can change the actual
      #value of the label in a way that would cause our markers to no longer be truthful to their positions relative to the graph.
      marker = BigDecimal((index - @marker_count).abs.to_s) * BigDecimal(@increment.to_s) + BigDecimal(@minimum_value.to_s)
      marker_label = label(marker, @increment)
      marker_normalized = BigDecimal(marker_label)
      marker_percentage = (marker_normalized - BigDecimal(@minimum_value.to_s)) / BigDecimal(@spread.to_s)

      x = (@graph_width * marker_percentage) + @graph_left
      @d = @d.line(x, @graph_bottom, x, @graph_top)

      unless @hide_line_numbers
        @d.fill = @font_color
        @d.font = @font if @font
        @d.stroke = 'transparent'
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = CenterGravity
        # TODO Center text over line
        @d = @d.annotate_scaled(@base_image,
                                0, 0, # Width of box to draw text in
                                x, @graph_bottom + (LABEL_MARGIN * 2.0), # Coordinates of text
                                marker_label.to_s, @scale)
      end # unless
      @d = @d.stroke_antialias true
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index, label=nil)
    if !@labels[index].nil? && @labels_seen[index].nil?
      lbl = (@use_data_label) ? label : @labels[index]
      @d.fill = @font_color
      @d.font = @font if @font
      @d.stroke = 'transparent'
      @d.font_weight = NormalWeight
      @d.pointsize = scale_fontsize(@marker_font_size)
      @d.gravity = EastGravity
      @d = @d.annotate_scaled(@base_image,
                              1, 1,
                              -@graph_left + LABEL_MARGIN * 2.0, y_offset,
                              lbl, @scale)
      @labels_seen[index] = 1
    end
  end
end

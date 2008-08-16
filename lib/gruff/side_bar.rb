require File.dirname(__FILE__) + '/base'

##
# Graph with individual horizontal bars instead of vertical bars.

class Gruff::SideBar < Gruff::Base

  def draw
    @has_left_labels = true
    super

    return unless @has_data

    # Setup spacing.
    #
    spacing_factor = 0.9

    @bars_width = @graph_height / @column_count.to_f
    @bar_width = @bars_width * spacing_factor / @norm_data.size
    @d         = @d.stroke_opacity 0.0
    height     = Array.new(@column_count, 0)
    length     = Array.new(@column_count, @graph_left)

    @norm_data.each_with_index do |data_row, row_index|
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|

        # Using the original calcs from the stacked bar chart
        # to get the difference between
        # part of the bart chart we wish to stack.
        temp1      = @graph_left + (@graph_width - data_point * @graph_width - height[point_index])
        temp2      = @graph_left + @graph_width - height[point_index]
        difference = temp2 - temp1

        left_x     = length[point_index] - 1
        left_y     = @graph_top + (@bars_width * point_index) + (@bar_width * row_index)
        right_x    = left_x + difference
        right_y    = left_y + @bar_width

        height[point_index] += (data_point * @graph_width)

        @d           = @d.rectangle(left_x, left_y, right_x, right_y)

        # Calculate center based on bar_width and current row
        label_center = @graph_top + (@bars_width * point_index + @bars_width / 2)
        draw_label(label_center, point_index)
      end

    end

    @d.draw(@base_image)
  end

protected

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers

    return if @hide_line_markers

    @d = @d.stroke_antialias false

    # Draw horizontal line markers and annotate with numbers
    @d = @d.stroke(@marker_color)
    @d = @d.stroke_width 1
    number_of_lines = 5

    # TODO Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
    increment = significant(@maximum_value.to_f / number_of_lines)
    (0..number_of_lines).each do |index|

      line_diff    = (@graph_right - @graph_left) / number_of_lines
      x            = @graph_right - (line_diff * index) - 1
      @d           = @d.line(x, @graph_bottom, x, @graph_top)
      diff         = index - number_of_lines
      marker_label = diff.abs * increment

      unless @hide_line_numbers
        @d.fill      = @font_color
        @d.font      = @font if @font
        @d.stroke    = 'transparent'
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity   = CenterGravity
        # TODO Center text over line
        @d           = @d.annotate_scaled( @base_image,
                          0, 0, # Width of box to draw text in
                          x, @graph_bottom + (LABEL_MARGIN * 2.0), # Coordinates of text
                          marker_label.to_s, @scale)
      end # unless
      @d = @d.stroke_antialias true
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index)
    if !@labels[index].nil? && @labels_seen[index].nil?
      @d.fill             = @font_color
      @d.font             = @font if @font
      @d.stroke           = 'transparent'
      @d.font_weight      = NormalWeight
      @d.pointsize        = scale_fontsize(@marker_font_size)
      @d.gravity          = EastGravity
      @d                  = @d.annotate_scaled(@base_image,
                              1, 1,
                              -@graph_left + LABEL_MARGIN * 2.0, y_offset,
                              @labels[index], @scale)
      @labels_seen[index] = 1
    end
  end

end

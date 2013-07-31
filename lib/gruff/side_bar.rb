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
    number_of_lines = @marker_count || 5
    number_of_lines = 1 if number_of_lines == 0

    # TODO Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
    increment = significant(@spread.to_f / number_of_lines)
    (0..number_of_lines).each do |index|

      line_diff = (@graph_right - @graph_left) / number_of_lines
      x = @graph_right - (line_diff * index) - 1
      @d = @d.line(x, @graph_bottom, x, @graph_top)
      diff = index - number_of_lines
      marker_label = diff.abs * increment + @minimum_value

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

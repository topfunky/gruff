require File.dirname(__FILE__) + '/base'

##
# Graph with dots and labels along a vertical access
# see: 'Creating More Effective Graphs' by Robbins

class Gruff::Dot < Gruff::Base

  def draw
    @has_left_labels = true
    super

    return unless @has_data

    # Setup spacing.
    #
    spacing_factor = 1.0

    @items_width = @graph_height / @column_count.to_f
    @item_width = @items_width * spacing_factor / @norm_data.size
    @d = @d.stroke_opacity 0.0
    padding = (@items_width * (1 - spacing_factor)) / 2

    @norm_data.each_with_index do |data_row, row_index|
      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
        x_pos = @graph_left + (data_point * @graph_width)
        y_pos = @graph_top + (@items_width * point_index) + padding + (@items_width.to_f/2.0).round

        if row_index == 0
          @d = @d.stroke(@marker_color)
          @d = @d.fill(@marker_color)
          @d = @d.stroke_width 1.0
          @d = @d.stroke_opacity 0.1
          @d = @d.fill_opacity 0.1
          @d = @d.line(@graph_left, y_pos, @graph_left + @graph_width, y_pos)
          @d = @d.fill_opacity 1
        end

        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke('transparent')
        @d = @d.circle(x_pos, y_pos, x_pos + (@item_width.to_f/3.0).round, y_pos)

        draw_label(y_pos, point_index)
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
    if @y_axis_increment
      increment = @y_axis_increment
      number_of_lines = (@spread / @y_axis_increment).to_i
    else
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
      # TODO Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
      @increment = (@spread > 0 && @marker_count > 0) ? significant(@spread / @marker_count) : 1

      number_of_lines = @marker_count
      increment = @increment
    end

    (0..number_of_lines).each do |index|
      marker_label = @minimum_value + index * increment
      x = @graph_left + (marker_label - @minimum_value) * @graph_width / @spread
      @d = @d.line(x, @graph_bottom, x, @graph_bottom + 0.5 * LABEL_MARGIN)

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
                                label(marker_label, increment), @scale)
      end # unless
      @d = @d.stroke_antialias true
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index)
    if !@labels[index].nil? && @labels_seen[index].nil?
      @d.fill = @font_color
      @d.font = @font if @font
      @d.stroke = 'transparent'
      @d.font_weight = NormalWeight
      @d.pointsize = scale_fontsize(@marker_font_size)
      @d.gravity = EastGravity
      @d = @d.annotate_scaled(@base_image,
                              1, 1,
                              -@graph_left + LABEL_MARGIN * 2.0, y_offset,
                              @labels[index], @scale)
      @labels_seen[index] = 1
    end
  end

end

require File.dirname(__FILE__) + '/base'

# Experimental!!! See also the Spider graph.
class Gruff::Net < Gruff::Base

  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots

  # Dimensions of lines and dots; calculated based on dataset size if left unspecified
  attr_accessor :line_width
  attr_accessor :dot_radius

  def initialize(*args)
    super

    @hide_dots = false
    @hide_line_numbers = true
    @sorted_drawing = true
  end

  def draw
    super

    return unless @has_data

    @radius = @graph_height / 2.0
    @center_x = @graph_left + (@graph_width / 2.0)
    @center_y = @graph_top + (@graph_height / 2.0) - 10 # Move graph up a bit

    @x_increment = @graph_width / (@column_count - 1).to_f
    circle_radius = dot_radius ||
        clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)

    @d = @d.stroke_opacity 1.0
    @d = @d.stroke_width line_width ||
                             clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)

    if defined?(@norm_baseline)
      level = @graph_top + (@graph_height - @norm_baseline * @graph_height)
      @d = @d.push
      @d.stroke_color @baseline_color
      @d.fill_opacity 0.0
      @d.stroke_dasharray(10, 20)
      @d.stroke_width 5
      @d.line(@graph_left, level, @graph_left + @graph_width, level)
      @d = @d.pop
    end

    @norm_data.each do |data_row|
      @d = @d.stroke data_row[DATA_COLOR_INDEX]
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        next if data_point.nil?

        rad_pos = index * Math::PI * 2 / @column_count
        point_distance = data_point * @radius
        start_x = @center_x + Math::sin(rad_pos) * point_distance
        start_y = @center_y - Math::cos(rad_pos) * point_distance

        next_index = index + 1 < data_row[DATA_VALUES_INDEX].length ? index + 1 : 0

        next_rad_pos = next_index * Math::PI * 2 / @column_count
        next_point_distance = data_row[DATA_VALUES_INDEX][next_index] * @radius
        end_x = @center_x + Math::sin(next_rad_pos) * next_point_distance
        end_y = @center_y - Math::cos(next_rad_pos) * next_point_distance

        @d = @d.line(start_x, start_y, end_x, end_y)

        @d = @d.circle(start_x, start_y, start_x - circle_radius, start_y) unless @hide_dots
      end

    end

    @d.draw(@base_image)
  end


  # the lines connecting in the center, with the first line vertical
  def draw_line_markers
    return if @hide_line_markers


    # have to do this here (AGAIN)... see draw() in this class
    # because this funtion is called before the @radius, @center_x and @center_y are set
    @radius = @graph_height / 2.0
    @center_x = @graph_left + (@graph_width / 2.0)
    @center_y = @graph_top + (@graph_height / 2.0) - 10 # Move graph up a bit


    # Draw horizontal line markers and annotate with numbers
    @d = @d.stroke(@marker_color)
    @d = @d.stroke_width 1


    (0..@column_count-1).each do |index|
      rad_pos = index * Math::PI * 2 / @column_count

      @d = @d.line(@center_x, @center_y, @center_x + Math::sin(rad_pos) * @radius, @center_y - Math::cos(rad_pos) * @radius)


      marker_label = labels[index] ? labels[index].to_s : '000'

      draw_label(@center_x, @center_y, rad_pos * 360 / (2 * Math::PI), @radius, marker_label)
    end
  end

  private

  def draw_label(center_x, center_y, angle, radius, amount)
    r_offset = 1.1
    x_offset = center_x # + 15 # The label points need to be tweaked slightly
    y_offset = center_y # + 0  # This one doesn't though
    x = x_offset + (radius * r_offset * Math.sin(deg2rad(angle)))
    y = y_offset - (radius * r_offset * Math.cos(deg2rad(angle)))

    # Draw label
    @d.fill = @marker_color
    @d.font = @font if @font
    @d.pointsize = scale_fontsize(20)
    @d.stroke = 'transparent'
    @d.font_weight = BoldWeight
    @d.gravity = CenterGravity
    @d.annotate_scaled(@base_image, 0, 0, x, y, amount, @scale)
  end

end

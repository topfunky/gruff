# frozen_string_literal: true

# See also the Spider graph.
#
# Here's how to make a Gruff::Net.
#
#   g = Gruff::Net.new
#   g.title = "Net Graph"
#   g.labels = {
#     0 => '5/6',
#     1 => '5/15',
#     2 => '5/24',
#     3 => '5/30',
#     4 => '6/4',
#     5 => '6/12',
#     6 => '6/21',
#     7 => '6/28'
#   }
#   g.line_width = 3
#   g.dot_radius = 4
#   g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
#   g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
#   g.write("net.png")
#
class Gruff::Net < Gruff::Base
  # Hide parts of the graph to fit more data points, or for a different appearance.
  attr_writer :hide_dots

  # Dimensions of lines and dots; calculated based on dataset size if left unspecified.
  attr_writer :line_width
  attr_writer :dot_radius

  def initialize_ivars
    super

    @hide_dots = false
    @line_width = nil
    @dot_radius = nil
    @hide_line_numbers = true
    @sorted_drawing = true
  end
  private :initialize_ivars

  def draw
    super

    return unless data_given?

    store.norm_data.each do |data_row|
      data_row.points.each_with_index do |data_point, index|
        next if data_point.nil?

        rad_pos = index * Math::PI * 2 / column_count
        point_distance = data_point * @radius
        start_x = @center_x + Math.sin(rad_pos) * point_distance
        start_y = @center_y - Math.cos(rad_pos) * point_distance

        next_index = index + 1 < data_row.points.length ? index + 1 : 0

        next_rad_pos = next_index * Math::PI * 2 / column_count
        next_point_distance = data_row.points[next_index] * @radius
        end_x = @center_x + Math.sin(next_rad_pos) * next_point_distance
        end_y = @center_y - Math.cos(next_rad_pos) * next_point_distance

        Gruff::Renderer::Line.new(color: data_row.color, width: @stroke_width).render(start_x, start_y, end_x, end_y)

        unless @hide_dots
          circle_renderer = Gruff::Renderer::Circle.new(color: data_row.color, width: @stroke_width)
          circle_renderer.render(start_x, start_y, start_x - @circle_radius, start_y)
        end
      end
    end
  end

private

  def setup_drawing
    super

    @radius = @graph_height / 2.0
    @circle_radius = @dot_radius || clip_value_if_greater_than(@columns / (store.norm_data.first.points.size * 2.5), 5.0)
    @stroke_width  = @line_width || clip_value_if_greater_than(@columns / (store.norm_data.first.points.size * 4), 5.0)
    @center_x = @graph_left + (@graph_width / 2.0)
    @center_y = @graph_top + (@graph_height / 2.0) + 10
  end

  # the lines connecting in the center, with the first line vertical
  def draw_line_markers
    return if @hide_line_markers

    # Draw horizontal line markers and annotate with numbers
    (0..column_count - 1).each do |index|
      rad_pos = index * Math::PI * 2 / column_count

      Gruff::Renderer::Line.new(color: @marker_color)
                           .render(@center_x, @center_y, @center_x + Math.sin(rad_pos) * @radius, @center_y - Math.cos(rad_pos) * @radius)

      marker_label = @labels[index] ? @labels[index].to_s : '000'
      draw_label(@center_x, @center_y, rad_pos * 360 / (2 * Math::PI), @radius + @circle_radius, marker_label)
    end
  end

  def draw_label(center_x, center_y, angle, radius, amount)
    x_offset = center_x # + 15 # The label points need to be tweaked slightly
    y_offset = center_y # + 0  # This one doesn't though
    x = x_offset + (radius + LABEL_MARGIN) * Math.sin(deg2rad(angle))
    y = y_offset - (radius + LABEL_MARGIN) * Math.cos(deg2rad(angle))

    # Draw label
    text_renderer = Gruff::Renderer::Text.new(amount, font: @font, size: 20, color: @marker_color, weight: Magick::BoldWeight)
    text_renderer.add_to_render_queue(0, 0, x, y, Magick::CenterGravity)
  end
end

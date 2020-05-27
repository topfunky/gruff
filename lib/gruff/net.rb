# frozen_string_literal: true

require 'gruff/base'

# Experimental!!! See also the Spider graph.
class Gruff::Net < Gruff::Base
  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots

  # Dimensions of lines and dots; calculated based on dataset size if left unspecified.
  attr_accessor :line_width
  attr_accessor :dot_radius

  def initialize_ivars
    super

    @hide_dots = false
    @hide_line_numbers = true
    @sorted_drawing = true
  end
  private :initialize_ivars

  def draw
    super

    return unless data_given?

    stroke_width = line_width  || clip_value_if_greater_than(@columns / (store.norm_data.first.points.size * 4), 5.0)
    circle_radius = dot_radius || clip_value_if_greater_than(@columns / (store.norm_data.first.points.size * 2.5), 5.0)

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

        Gruff::Renderer::Line.new(color: data_row.color, width: stroke_width).render(start_x, start_y, end_x, end_y)

        Gruff::Renderer::Circle.new(color: data_row.color, width: stroke_width).render(start_x, start_y, start_x - circle_radius, start_y) unless @hide_dots
      end
    end

    Gruff::Renderer.finish
  end

private

  def setup_drawing
    super

    @radius = @graph_height / 2.0
    @center_x = @graph_left + (@graph_width / 2.0)
    @center_y = @graph_top + (@graph_height / 2.0) - 10 # Move graph up a bit
  end

  # the lines connecting in the center, with the first line vertical
  def draw_line_markers
    return if @hide_line_markers

    # Draw horizontal line markers and annotate with numbers
    (0..column_count - 1).each do |index|
      rad_pos = index * Math::PI * 2 / column_count

      Gruff::Renderer::Line.new(color: @marker_color)
                           .render(@center_x, @center_y, @center_x + Math.sin(rad_pos) * @radius, @center_y - Math.cos(rad_pos) * @radius)

      marker_label = labels[index] ? labels[index].to_s : '000'
      draw_label(@center_x, @center_y, rad_pos * 360 / (2 * Math::PI), @radius, marker_label)
    end
  end

  def draw_label(center_x, center_y, angle, radius, amount)
    r_offset = 1.1
    x_offset = center_x # + 15 # The label points need to be tweaked slightly
    y_offset = center_y # + 0  # This one doesn't though
    x = x_offset + (radius * r_offset * Math.sin(deg2rad(angle)))
    y = y_offset - (radius * r_offset * Math.cos(deg2rad(angle)))

    # Draw label
    text_renderer = Gruff::Renderer::Text.new(amount, font: @font, size: 20, color: @marker_color, weight: Magick::BoldWeight)
    text_renderer.render(0, 0, x, y, Magick::CenterGravity)
  end
end

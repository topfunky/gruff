# frozen_string_literal: true

require 'gruff/base'

# Experimental!!! See also the Net graph.
#
# Here's how to set up a Gruff::Spider.
#
#   g = Gruff::Spider.new(30)
#   g.title = "Spider Graph"
#   g.data :Strength, [10]
#   g.data :Dexterity, [16]
#   g.data :Constitution, [12]
#   g.data :Intelligence, [12]
#   g.data :Wisdom, [10]
#   g.data 'Charisma', [16]
#   g.write("spider.png")

class Gruff::Spider < Gruff::Base
  # Hide all text.
  attr_writer :hide_axes
  attr_writer :rotation

  def transparent_background=(value)
    Gruff::Renderer.setup_transparent_background(@columns, @rows) if value
  end

  def hide_text=(value)
    @hide_title = @hide_text = value
  end

  def initialize(max_value, target_width = 800)
    super(target_width)
    @max_value = max_value
  end

  def initialize_ivars
    super
    @hide_legend = true
    @hide_axes = false
    @hide_text = false
    @rotation = 0
  end
  private :initialize_ivars

  def draw
    @hide_line_markers = true

    super

    return unless data_given?

    # Setup basic positioning
    radius = @graph_height / 2.0
    center_x = @graph_left + (@graph_width / 2.0)
    center_y = @graph_top + (@graph_height / 2.0) - 25 # Move graph up a bit

    @unit_length = radius / @max_value

    additive_angle = (2 * Math::PI) / store.length

    # Draw axes
    draw_axes(center_x, center_y, radius, additive_angle) unless @hide_axes

    # Draw polygon
    draw_polygon(center_x, center_y, additive_angle)

    Gruff::Renderer.finish
  end

private

  def normalize_points(value)
    value * @unit_length
  end

  def draw_label(center_x, center_y, angle, radius, amount)
    r_offset = 50            # The distance out from the center of the pie to get point
    x_offset = center_x      # The label points need to be tweaked slightly
    y_offset = center_y + 0  # This one doesn't though
    x = x_offset + ((radius + r_offset) * Math.cos(angle))
    y = y_offset + ((radius + r_offset) * Math.sin(angle))

    # Draw label
    text_renderer = Gruff::Renderer::Text.new(amount, font: @font, size: @legend_font_size, color: @marker_color, weight: Magick::BoldWeight)
    text_renderer.add_to_render_queue(0, 0, x, y, Magick::CenterGravity)
  end

  def draw_axes(center_x, center_y, radius, additive_angle, line_color = nil)
    return if @hide_axes

    current_angle = @rotation * Math::PI / 180.0

    store.data.each do |data_row|
      x_offset = radius * Math.cos(current_angle)
      y_offset = radius * Math.sin(current_angle)

      Gruff::Renderer::Line.new(color: line_color || data_row.color, width: 5.0)
                           .render(center_x, center_y, center_x + x_offset, center_y + y_offset)

      draw_label(center_x, center_y, current_angle, radius, data_row.label.to_s) unless @hide_text

      current_angle += additive_angle
    end
  end

  def draw_polygon(center_x, center_y, additive_angle, color = nil)
    points = []
    current_angle = @rotation * Math::PI / 180.0

    store.data.each do |data_row|
      points << center_x + normalize_points(data_row.points.first) * Math.cos(current_angle)
      points << center_y + normalize_points(data_row.points.first) * Math.sin(current_angle)
      current_angle += additive_angle
    end

    Gruff::Renderer::Polygon.new(color: color || @marker_color, opacity: 0.4).render(points)
  end

  def sums_for_spider
    store.data.sum { |data_row| data_row.points.first }
  end
end

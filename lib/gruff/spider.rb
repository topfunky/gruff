# frozen_string_literal: true

# rbs_inline: enabled

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
#
class Gruff::Spider < Gruff::Base
  # Hide all text.
  attr_writer :hide_axes #: bool
  attr_writer :rotation #: Float | Integer

  # @rbs max_value: Float | Integer
  # @rbs target_width: (String | Float | Integer)
  # @rbs return: void
  def initialize(max_value, target_width = 800)
    super(target_width)
    @max_value = max_value
  end

  # @rbs value: bool
  def hide_text=(value)
    @hide_title = @hide_text = value
  end

private

  def initialize_attributes
    super
    @hide_legend = true
    @hide_axes = false
    @hide_text = false
    @rotation = 0
    @marker_font.bold = true

    @hide_line_markers = true
    @hide_line_markers.freeze
  end

  def setup_drawing
    @center_labels_over_point = false
    super
  end

  def setup_graph_measurements
    super

    @graph_left += @label_margin
    @graph_top += @label_margin
    @graph_right -= @label_margin
    @graph_bottom -= @label_margin

    @graph_width = @graph_right - @graph_left
    @graph_height = @graph_bottom - @graph_top
  end

  def setup_data
    raise(Gruff::IncorrectNumberOfDatasetsException, 'Requires 3 or more data sets') if store.length < 3

    super
  end

  def draw_graph
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
  end

  # @rbs value: nil | Float | Integer
  def normalize_points(value)
    value.to_f * @unit_length
  end

  def draw_label(center_x, center_y, angle, radius, amount)
    degree = rad2deg(angle)
    metrics = text_metrics(@marker_font, amount)

    r_offset = @label_margin # The distance out from the center of the pie to get point
    x_offset = center_x # The label points need to be tweaked slightly

    x_offset -= begin
      case degree
      when 0..45, 315..360
        0
      when 135..225
        metrics.width
      else
        metrics.width / 2
      end
    end

    y_offset = center_y - (metrics.height / 2.0) # This one doesn't though
    x = x_offset + ((radius + r_offset) * Math.cos(angle))
    y = y_offset + ((radius + r_offset) * Math.sin(angle))

    draw_label_at(metrics.width, metrics.height, x, y, amount, gravity: Magick::CenterGravity)
  end

  def draw_axes(center_x, center_y, radius, additive_angle, line_color = nil)
    return if @hide_axes

    current_angle = deg2rad(@rotation)

    store.data.each do |data_row|
      x_offset = radius * Math.cos(current_angle)
      y_offset = radius * Math.sin(current_angle)

      Gruff::Renderer::Line.new(renderer, color: line_color || data_row.color, width: 5.0)
                           .render(center_x, center_y, center_x + x_offset, center_y + y_offset)

      draw_label(center_x, center_y, current_angle, radius, data_row.label.to_s) unless @hide_text

      current_angle += additive_angle
    end
  end

  def draw_polygon(center_x, center_y, additive_angle, color = nil)
    points = []
    current_angle = deg2rad(@rotation)

    store.data.each do |data_row|
      points << (center_x + (normalize_points(data_row.points.first) * Math.cos(current_angle)))
      points << (center_y + (normalize_points(data_row.points.first) * Math.sin(current_angle)))
      current_angle += additive_angle
    end

    Gruff::Renderer::Polygon.new(renderer, color: color || @marker_color, opacity: 0.4).render(points)
  end
end

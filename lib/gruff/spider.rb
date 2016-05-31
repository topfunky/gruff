
require File.dirname(__FILE__) + '/base'

# Experimental!!! See also the Net graph.
#
# Submitted by Kevin Clark http://glu.ttono.us/
class Gruff::Spider < Gruff::Base
  
  # Hide all text
  attr_reader :hide_text
  attr_accessor :hide_axes
  attr_reader :transparent_background
  attr_accessor :rotation
  
  def transparent_background=(value)
    @transparent_background = value
    @base_image = render_transparent_background if value
  end

  def hide_text=(value)
    @hide_title = @hide_text = value
  end

  def initialize(max_value, target_width = 800)
    super(target_width)
    @max_value = max_value
    @hide_legend = true
    @rotation = 0
  end
  
  def draw
    @hide_line_markers = true
    
    super

    return unless @has_data

    # Setup basic positioning
    radius = @graph_height / 2.0
    center_x = @graph_left + (@graph_width / 2.0)
    center_y = @graph_top + (@graph_height / 2.0) - 25 # Move graph up a bit

    @unit_length = radius / @max_value
        
    additive_angle = (2 * Math::PI)/ @data.size
    
    # Draw axes
    draw_axes(center_x, center_y, radius, additive_angle) unless hide_axes    

    # Draw polygon
    draw_polygon(center_x, center_y, additive_angle)

    @d.draw(@base_image)
  end

private

  def normalize_points(value)
    value * @unit_length
  end

  def draw_label(center_x, center_y, angle, radius, amount)
    r_offset = 50      # The distance out from the center of the pie to get point
    x_offset = center_x      # The label points need to be tweaked slightly
    y_offset = center_y + 0  # This one doesn't though
    x = x_offset + ((radius + r_offset) * Math.cos(angle))
    y = y_offset + ((radius + r_offset) * Math.sin(angle))

    # Draw label
    @d.fill = @marker_color
    @d.font = @font if @font
    @d.pointsize = scale_fontsize(legend_font_size)
    @d.stroke = 'transparent'
    @d.font_weight = BoldWeight
    @d.gravity = CenterGravity
    @d.annotate_scaled( @base_image, 
                      0, 0,
                      x, y, 
                      amount, @scale)
  end

  def draw_axes(center_x, center_y, radius, additive_angle, line_color = nil)
    return if hide_axes

    current_angle = rotation * Math::PI / 180.0

    @data.each do |data_row|
      @d.stroke(line_color || data_row[DATA_COLOR_INDEX])
      @d.stroke_width 5.0

      x_offset = radius * Math.cos(current_angle)
      y_offset = radius * Math.sin(current_angle)

      @d.line(center_x, center_y,
              center_x + x_offset,
              center_y + y_offset)

      draw_label(center_x, center_y, current_angle, radius, data_row[DATA_LABEL_INDEX].to_s) unless hide_text

      current_angle += additive_angle
    end
  end

  def draw_polygon(center_x, center_y, additive_angle, color = nil)
    points = []
    current_angle = rotation * Math::PI / 180.0

    @data.each do |data_row|
      points << center_x + normalize_points(data_row[DATA_VALUES_INDEX].first) * Math.cos(current_angle)
      points << center_y + normalize_points(data_row[DATA_VALUES_INDEX].first) * Math.sin(current_angle)
      current_angle += additive_angle
    end

    @d.stroke_width 1.0
    @d.stroke(color || @marker_color)
    @d.fill(color || @marker_color)
    @d.fill_opacity 0.4
    @d.polygon(*points)
  end

  def sums_for_spider
    @data.inject(0.0) {|sum, data_row| sum + data_row[DATA_VALUES_INDEX].first}
  end

end

# frozen_string_literal: true

#
# Gruff::Area provides an area graph which displays graphically
# quantitative data.
#
# Here's how to set up a Gruff::Area.
#
#   g = Gruff::Area.new
#   g.title = 'Area Graph'
#   g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
#   g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
#   g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
#   g.write('area.png')
#
class Gruff::Area < Gruff::Base
  # Specifies the filling opacity in area graph. Default is +0.85+.
  attr_writer :fill_opacity

  # Specifies the stroke width in line around area graph. Default is +2.0+.
  attr_writer :stroke_width

  def initialize_ivars
    super
    @sorted_drawing = true
    @fill_opacity = 0.85
    @stroke_width = 2.0
  end
  private :initialize_ivars

  def draw
    super

    return unless data_given?

    x_increment = @graph_width / (column_count - 1).to_f

    store.norm_data.each do |data_row|
      poly_points = []

      data_row.points.each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (x_increment * index)
        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        poly_points << new_x
        poly_points << new_y

        draw_label(new_x, index)
      end

      # Add closing points, draw polygon
      poly_points << @graph_right
      poly_points << @graph_bottom - 1
      poly_points << @graph_left
      poly_points << @graph_bottom - 1

      Gruff::Renderer::Polygon.new(color: data_row.color, width: @stroke_width, opacity: @fill_opacity).render(poly_points)
    end
  end
end

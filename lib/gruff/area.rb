require File.dirname(__FILE__) + '/base'

class Gruff::Area < Gruff::Base
  def initialize(*)
    super
    @sorted_drawing = true
  end

  def draw
    super

    return unless data_given?

    @x_increment = @graph_width / (column_count - 1).to_f
    @d = @d.stroke 'transparent'

    @norm_data.each do |data_row|
      poly_points = Array.new
      @d = @d.fill data_row.color

      data_row.points.each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (@x_increment * index)
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

      @d = @d.polyline(*poly_points)
    end

    @d.draw(@base_image)
  end
end

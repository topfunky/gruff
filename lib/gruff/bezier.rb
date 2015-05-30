require File.dirname(__FILE__) + '/base'

class Gruff::Bezier < Gruff::Base
  def draw
    super

    return unless @has_data

    @x_increment = @graph_width / (@column_count - 1).to_f

    @norm_data.each do |data_row|
      poly_points = Array.new
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[1].each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (@x_increment * index)
        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        if index == 0 && RUBY_PLATFORM != 'java'
          poly_points << new_x
          poly_points << new_y
        end

        poly_points << new_x
        poly_points << new_y

        draw_label(new_x, index)
      end
   
      @d = @d.fill_opacity 0.0
      @d = @d.stroke data_row[DATA_COLOR_INDEX]
      @d = @d.stroke_width clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 4), 5.0)

      if RUBY_PLATFORM == 'java'
        @d = @d.polyline(*poly_points)
      else
        @d = @d.bezier(*poly_points)
      end
    end

    @d.draw(@base_image)
  end
   

end

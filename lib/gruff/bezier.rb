
require File.dirname(__FILE__) + '/base'

class Gruff::Bezier < Gruff::Base

  def draw
    super

    return unless @has_data

    @x_increment = @graph_width / (@column_count - 1).to_f


    @norm_data.each do |data_row|
      poly_points = Array.new
      prev_x = prev_y = 0.0
      @d = @d.fill data_row[DATA_COLOR_INDEX]
      
      
      data_row[1].each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (@x_increment * index)
        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        if prev_x >= 0 and prev_y >= 0 then
          poly_points << new_x
          poly_points << new_y
          
        else
          poly_points << @graph_left
          poly_points << @graph_bottom - 1
          poly_points << new_x
          poly_points << new_y
           
        end

        draw_label(new_x, index)

        prev_x = new_x
        prev_y = new_y
      end
   
      @d = @d.fill_opacity 0.0
      @d = @d.stroke data_row[DATA_COLOR_INDEX]
      @d = @d.stroke_width clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 4), 5.0)
      
      @d = @d.bezier(*poly_points)
    end

    @d.draw(@base_image)
  end
   
 
end

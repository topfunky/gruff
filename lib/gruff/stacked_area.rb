
require File.dirname(__FILE__) + '/base'
require File.dirname(__FILE__) + '/stacked_mixin'

class Gruff::StackedArea < Gruff::Base
  include StackedMixin
  attr_accessor :last_series_goes_on_bottom
  
  def draw
    get_maximum_by_stack
    super

    return unless @has_data

    @x_increment = @graph_width / (@column_count - 1).to_f
    @d = @d.stroke 'transparent'

    height = Array.new(@column_count, 0)

    data_points = nil
    iterator = last_series_goes_on_bottom ? :reverse_each : :each
    @norm_data.send(iterator) do |data_row|
      prev_data_points = data_points
      data_points = Array.new
        
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (@x_increment * index)
        new_y = @graph_top + (@graph_height - data_point * @graph_height - height[index])

        height[index] += (data_point * @graph_height)
        
        data_points << new_x
        data_points << new_y
          
        draw_label(new_x, index)

      end

      if prev_data_points
        poly_points = data_points.dup
        (prev_data_points.length/2 - 1).downto(0) do |i|
          poly_points << prev_data_points[2*i] 
          poly_points << prev_data_points[2*i+1]
        end
        poly_points << data_points[0] 
        poly_points << data_points[1] 
      else
        poly_points = data_points.dup
        poly_points << @graph_right
        poly_points << @graph_bottom - 1
        poly_points << @graph_left
        poly_points << @graph_bottom - 1
        poly_points << data_points[0] 
        poly_points << data_points[1] 
      end
      @d = @d.polyline(*poly_points)

    end

    @d.draw(@base_image)
  end
   
 
end

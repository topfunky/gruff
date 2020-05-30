# frozen_string_literal: true

require 'gruff/base'
require 'gruff/helper/stacked_mixin'

#
# Here's how to set up a Gruff::StackedArea.
#
#   g = Gruff::StackedArea.new
#   g.title = 'StackedArea Graph'
#   g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
#   g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
#   g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
#   g.write('stacked_area.png')
#
class Gruff::StackedArea < Gruff::Base
  include StackedMixin
  attr_accessor :last_series_goes_on_bottom

  def draw
    calculate_maximum_by_stack
    super

    return unless data_given?

    x_increment = @graph_width / (column_count - 1).to_f

    height = Array.new(column_count, 0)

    data_points = nil
    iterator = last_series_goes_on_bottom ? :reverse_each : :each
    store.norm_data.public_send(iterator) do |data_row|
      prev_data_points = data_points
      data_points = []

      data_row.points.each_with_index do |data_point, index|
        # Use incremented x and scaled y
        new_x = @graph_left + (x_increment * index)
        new_y = @graph_top + (@graph_height - data_point * @graph_height - height[index])

        height[index] += (data_point * @graph_height)

        data_points << new_x
        data_points << new_y

        draw_label(new_x, index)
      end

      poly_points = data_points.dup
      if prev_data_points
        (prev_data_points.length / 2 - 1).downto(0) do |i|
          poly_points << prev_data_points[2 * i]
          poly_points << prev_data_points[2 * i + 1]
        end
      else
        poly_points << @graph_right
        poly_points << @graph_bottom - 1
        poly_points << @graph_left
        poly_points << @graph_bottom - 1
      end
      poly_points << data_points[0]
      poly_points << data_points[1]

      Gruff::Renderer::Polygon.new(color: data_row.color).render(poly_points)
    end

    Gruff::Renderer.finish
  end
end

# frozen_string_literal: true

require 'gruff/base'
require 'gruff/stacked_mixin'

class Gruff::StackedArea < Gruff::Base
  include StackedMixin
  attr_accessor :last_series_goes_on_bottom

  def draw
    get_maximum_by_stack
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

      Gruff::Renderer::Polyline.new(color: data_row.color).render(poly_points)
    end

    Gruff::Renderer.finish
  end
end

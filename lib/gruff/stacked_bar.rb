# frozen_string_literal: true

require 'gruff/base'
require 'gruff/stacked_mixin'

class Gruff::StackedBar < Gruff::Base
  include StackedMixin

  # Spacing factor applied between bars
  attr_accessor :bar_spacing

  # Number of pixels between bar segments
  attr_accessor :segment_spacing

  # Draws a bar graph, but multiple sets are stacked on top of each other.
  def draw
    get_maximum_by_stack
    super
    return unless data_given?

    # Setup spacing.
    #
    # Columns sit stacked.
    @bar_spacing ||= 0.9
    @segment_spacing ||= 2

    bar_width = @graph_width / column_count.to_f
    padding = (bar_width * (1 - @bar_spacing)) / 2

    height = Array.new(column_count, 0)

    store.norm_data.each do |data_row|
      data_row.points.each_with_index do |data_point, point_index|
        next if data_point == 0

        # Use incremented x and scaled y
        left_x = @graph_left + (bar_width * point_index) + padding
        left_y = @graph_top + (@graph_height -
                               data_point * @graph_height -
                               height[point_index]) + @segment_spacing
        right_x = left_x + bar_width * @bar_spacing
        right_y = @graph_top + @graph_height - height[point_index]

        # update the total height of the current stacked bar
        height[point_index] += (data_point * @graph_height)

        rect_renderer = Gruff::Renderer::Rectangle.new(color: data_row.color)
        rect_renderer.render(left_x, left_y, right_x, right_y)

        # Calculate center based on bar_width and current row
        label_center = left_x + bar_width * @bar_spacing / 2.0
        draw_label(label_center, point_index)
      end
    end

    Gruff::Renderer.finish
  end
end

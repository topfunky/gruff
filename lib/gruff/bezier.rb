# frozen_string_literal: true

# rbs_inline: enabled

#
# Gruff::Bezier is a special line graph that have
# the bezier curve.
#
# Here's how to set up a Gruff::Bezier.
#
#   dataset = [
#     +0.00, +0.09, +0.19, +0.29, +0.38, +0.47, +0.56, +0.64, +0.71, +0.78,
#     +0.84, +0.89, +0.93, +0.96, +0.98, +0.99, +0.99, +0.99, +0.97, +0.94,
#     +0.90, +0.86, +0.80, +0.74, +0.67, +0.59, +0.51, +0.42, +0.33, +0.23,
#     +0.14, +0.04, -0.06, -0.16, -0.26, -0.36, -0.45, -0.53, -0.62, -0.69,
#     -0.76, -0.82, -0.88, -0.92, -0.96, -0.98, -1.00, -1.00, -1.00, -0.99,
#     -0.96, -0.93, -0.89, -0.84, -0.78, -0.71, -0.64, -0.56, -0.47, -0.38,
#   ]
#   g = Gruff::Bezier.new
#   g.data 'sin', dataset
#   g.write('bezier.png')
#
class Gruff::Bezier < Gruff::Base
private

  def draw_graph
    x_increment = (@graph_width / (column_count - 1)).to_f

    renderer_class = RUBY_PLATFORM == 'java' ? Gruff::Renderer::Polyline : Gruff::Renderer::Bezier
    stroke_width = clip_value_if_greater_than(@columns / (store.norm_data.first.points.size * 4.0), 5.0)

    store.norm_data.each do |data_row|
      next if data_row.points.empty?

      poly_points = []

      data_row.points.each_with_index do |data_point, index|
        data_point = data_point.to_f
        # Use incremented x and scaled y
        new_x = @graph_left + (x_increment * index)
        new_y = @graph_top + (@graph_height - (data_point * @graph_height))

        if index == 0 && RUBY_PLATFORM != 'java'
          poly_points << new_x
          poly_points << new_y
        end

        poly_points << new_x
        poly_points << new_y

        draw_label(new_x, index)
      end

      renderer_class.new(renderer, color: data_row.color, width: stroke_width).render(poly_points)
    end
  end
end

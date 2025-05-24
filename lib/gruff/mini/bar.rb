# frozen_string_literal: true

#
# Makes a small bar graph suitable for display at 200px or even smaller.
#
# Here's how to set up a Gruff::Mini::Bar.
#
#   g = Gruff::Mini::Bar.new
#   g.title = 'Mini Bar Graph'
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('mini_bar.png')
#
class Gruff::Mini::Bar < Gruff::Bar
private

  include Gruff::Mini::Legend

  def initialize_attributes
    super

    @hide_legend = true
    @hide_title = true
    @hide_line_numbers = true

    @marker_font.size = 50.0
    @legend_font.size = 50.0

    @minimum_value = 0.0
  end

  def setup_data
    expand_canvas_for_vertical_legend # steep:ignore
    super
  end

  def draw_graph
    super
    draw_vertical_legend # steep:ignore
  end
end

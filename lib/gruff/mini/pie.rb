# frozen_string_literal: true

#
# Makes a small pie graph suitable for display at 200px or even smaller.
#
# Here's how to set up a Gruff::Mini::Pie.
#
#   g = Gruff::Mini::Pie.new
#   g.title = "Visual Pie Graph Test"
#   g.data 'Fries', 20
#   g.data 'Hamburgers', 50
#   g.write("mini_pie_keynote.png")
#
class Gruff::Mini::Pie < Gruff::Pie
private

  include Gruff::Mini::Legend

  def initialize_attributes
    super

    @hide_legend = true
    @hide_title = true
    @hide_line_numbers = true

    @marker_font.size = 50.0
    @legend_font.size = 50.0
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

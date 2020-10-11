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
module Gruff
  module Mini
    # A class for drawing a small pie graph.
    class Pie < Gruff::Pie
      include Gruff::Mini::Legend

      def initialize_ivars
        super

        @hide_legend = true
        @hide_title = true
        @hide_line_numbers = true

        @marker_font_size = 60.0
        @legend_font_size = 60.0
      end
      private :initialize_ivars

      def draw
        expand_canvas_for_vertical_legend

        super

        draw_vertical_legend
      end
    end
  end
end

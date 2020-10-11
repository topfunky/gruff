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
module Gruff
  module Mini
    # A class for drawing a small bar graph.
    class Bar < Gruff::Bar
      include Gruff::Mini::Legend

      def initialize_ivars
        super

        @hide_legend = true
        @hide_title = true
        @hide_line_numbers = true

        @marker_font_size = 50.0
        @legend_font_size = 60.0

        @minimum_value = 0.0
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

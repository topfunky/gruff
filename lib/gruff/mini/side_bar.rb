# frozen_string_literal: true

#
# Makes a small side bar graph suitable for display at 200px or even smaller.
#
# Here's how to set up a Gruff::Mini::SideBar.
#
#   g = Gruff::Mini::SideBar.new
#   g.title = 'SideBar Graph'
#   g.labels = {
#     0 => '5/6',
#     1 => '5/15',
#     2 => '5/24',
#     3 => '5/30',
#   }
#   g.group_spacing = 20
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('mini_sidebar.png')
#
module Gruff
  module Mini
    # A class for drawing a small side bar graph.
    class SideBar < Gruff::SideBar
      include Gruff::Mini::Legend

      def initialize_ivars
        super
        @hide_legend = true
        @hide_title = true
        @hide_line_numbers = true

        @marker_font_size = 50.0
        @legend_font_size = 50.0
      end
      private :initialize_ivars

      def draw
        expand_canvas_for_vertical_legend

        super

        draw_vertical_legend

        Gruff::Renderer.finish
      end
    end
  end
end

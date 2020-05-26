# frozen_string_literal: true

##
#
# Makes a small bar graph suitable for display at 200px or even smaller.
#
module Gruff
  module Mini
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
        Gruff::Renderer.finish
      end
    end
  end
end

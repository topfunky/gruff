##
#
# Makes a small pie graph suitable for display at 200px or even smaller.
#
module Gruff
  module Mini

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

      def draw
        expand_canvas_for_vertical_legend

        super

        draw_vertical_legend

        @d.draw(@base_image)
      end # def draw

    end # class Pie

  end
end

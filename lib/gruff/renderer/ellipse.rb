# frozen_string_literal: true

module Gruff
  class Renderer::Ellipse
    def initialize(color:, width: 1.0)
      @color = color
      @width = width
    end

    def render(origin_x, origin_y, width, height, arc_start, arc_end)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke_width(@width)
      draw.stroke(@color)
      draw.fill('transparent')
      draw.ellipse(origin_x, origin_y, width, height, arc_start, arc_end)
      draw.pop
    end
  end
end

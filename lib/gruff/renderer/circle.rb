# frozen_string_literal: true

module Gruff
  class Renderer::Circle
    def initialize(args = {})
      @color = args[:color]
      @width = args[:width] || 1.0
    end

    def render(origin_x, origin_y, perim_x, perim_y)
      draw = Renderer.instance.draw

      draw.push
      draw.fill(@color)
      draw.stroke(@color)
      draw.stroke_width(@width)
      draw.circle(origin_x, origin_y, perim_x, perim_y)
      draw.pop
    end
  end
end

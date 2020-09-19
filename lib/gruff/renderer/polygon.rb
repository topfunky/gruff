# frozen_string_literal: true

module Gruff
  class Renderer::Polygon
    def initialize(color:, width: 1.0, opacity: 1.0)
      @color = color
      @width = width
      @opacity = opacity
    end

    def render(points)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke_width(@width)
      draw.stroke(@color)
      draw.fill(@color)
      draw.fill_opacity(@opacity)
      draw.polygon(*points)
      draw.pop
    end
  end
end

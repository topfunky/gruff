# frozen_string_literal: true

module Gruff
  class Renderer::Polygon
    def initialize(args = {})
      @color = args[:color]
      @width = args[:width] || 1.0
      @opacity = args[:opacity] || 1.0
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

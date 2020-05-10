# frozen_string_literal: true

module Gruff
  class Renderer::Bezier
    def initialize(args = {})
      @color = args[:color]
      @width = args[:width] || 1.0
    end

    def render(points)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke(@color)
      draw.stroke_width(@width)
      draw.fill_opacity(0.0)
      draw.bezier(*points)
      draw.pop
    end
  end
end

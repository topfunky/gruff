# frozen_string_literal: true

module Gruff
  class Renderer::Polyline
    def initialize(args = {})
      @color = args[:color]
      @width = args[:width]
    end

    def render(points)
      draw = Renderer.instance.draw

      draw.push
      if @width
        draw.stroke(@color)
        draw.stroke_width(@width)
        draw.fill_opacity(0.0)
      else
        draw.fill(@color)
        draw.stroke('transparent')
      end
      draw.polyline(*points)
      draw.pop
    end
  end
end

# frozen_string_literal: true

module Gruff
  class Renderer::Polyline
    def initialize(color:, width:)
      @color = color
      @width = width
    end

    def render(points)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke(@color)
      draw.fill('transparent')
      draw.stroke_width(@width)
      draw.polyline(*points)
      draw.pop
    end
  end
end

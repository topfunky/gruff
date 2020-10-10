# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Bezier
    def initialize(color:, width: 1.0)
      @color = color
      @width = width
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

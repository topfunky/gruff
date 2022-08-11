# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Polygon
    def initialize(renderer, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
    end

    def render(points)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill_opacity(@opacity)
      @renderer.draw.fill(@color)
      @renderer.draw.polygon(*points)
      @renderer.draw.pop
    end
  end
end

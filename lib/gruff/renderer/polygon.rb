# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Polygon
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs opacity: Float | Integer
    # @rbs return: void
    def initialize(renderer, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
    end

    # @rbs points: Array[Float | Integer]
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

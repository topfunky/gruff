# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Bezier
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs return: void
    def initialize(renderer, color:, width: 1.0)
      @renderer = renderer
      @color = color
      @width = width
    end

    # @rbs points: Array[Float | Integer]
    def render(points)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill_opacity(0.0)
      @renderer.draw.bezier(*points)
      @renderer.draw.pop
    end
  end
end

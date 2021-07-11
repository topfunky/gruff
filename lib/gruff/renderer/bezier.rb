# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Bezier
    def initialize(renderer, color:, width: 1.0)
      @renderer = renderer
      @color = color
      @width = width
    end

    def render(points)
      @renderer.draw.push
      @renderer.draw.stroke(@color)
      @renderer.draw.stroke_width(@width)
      @renderer.draw.fill_opacity(0.0)
      @renderer.draw.bezier(*points)
      @renderer.draw.pop
    end
  end
end

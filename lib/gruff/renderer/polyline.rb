# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Polyline
    def initialize(renderer, color:, width:)
      @renderer = renderer
      @color = color
      @width = width
    end

    def render(points)
      @renderer.draw.push
      @renderer.draw.stroke(@color)
      @renderer.draw.fill('transparent')
      @renderer.draw.stroke_width(@width)
      @renderer.draw.polyline(*points)
      @renderer.draw.pop
    end
  end
end

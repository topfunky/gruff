# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Polyline
    def initialize(renderer, color:, width: 1.0, linejoin: 'bevel')
      @renderer = renderer
      @color = color
      @width = width
      @linejoin = linejoin
    end

    def render(points)
      @renderer.draw.push
      @renderer.draw.stroke_linejoin(@linejoin)
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill('transparent')
      @renderer.draw.polyline(*points)
      @renderer.draw.pop
    end
  end
end

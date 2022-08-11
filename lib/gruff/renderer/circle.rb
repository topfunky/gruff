# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Circle
    def initialize(renderer, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
    end

    def render(origin_x, origin_y, perim_x, perim_y)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill_opacity(@opacity)
      @renderer.draw.fill(@color)
      @renderer.draw.circle(origin_x, origin_y, perim_x, perim_y)
      @renderer.draw.pop
    end
  end
end

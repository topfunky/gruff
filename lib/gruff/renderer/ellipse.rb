# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Ellipse
    def initialize(renderer, color:, width: 1.0)
      @renderer = renderer
      @color = color
      @width = width
    end

    def render(origin_x, origin_y, width, height, arc_start, arc_end)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill('transparent')
      @renderer.draw.ellipse(origin_x, origin_y, width, height, arc_start, arc_end)
      @renderer.draw.pop
    end
  end
end

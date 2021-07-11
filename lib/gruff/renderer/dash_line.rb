# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::DashLine
    def initialize(renderer, color:, width:)
      @renderer = renderer
      @color = color
      @width = width
    end

    def render(start_x, start_y, end_x, end_y)
      @renderer.draw.push
      @renderer.draw.stroke_color(@color)
      @renderer.draw.fill_opacity(0.0)
      @renderer.draw.stroke_dasharray(10, 20)
      @renderer.draw.stroke_width(@width)
      @renderer.draw.line(start_x, start_y, end_x, end_y)
      @renderer.draw.pop
    end
  end
end

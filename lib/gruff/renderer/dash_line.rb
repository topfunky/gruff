# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::DashLine
    def initialize(renderer, color:, width:, dasharray: [10, 20])
      @renderer = renderer
      @color = color
      @width = width
      @dasharray = dasharray
    end

    def render(start_x, start_y, end_x, end_y)
      @renderer.draw.push
      @renderer.draw.stroke_color(@color)
      @renderer.draw.fill_opacity(0.0)
      @renderer.draw.stroke_dasharray(*@dasharray)
      @renderer.draw.stroke_width(@width)
      @renderer.draw.line(start_x, start_y, end_x, end_y)
      @renderer.draw.pop
    end
  end
end

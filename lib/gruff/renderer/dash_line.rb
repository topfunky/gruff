# frozen_string_literal: true

module Gruff
  class Renderer::DashLine
    def initialize(color:, width:)
      @color = color
      @width = width
    end

    def render(start_x, start_y, end_x, end_y)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke_color(@color)
      draw.fill_opacity(0.0)
      draw.stroke_dasharray(10, 20)
      draw.stroke_width(@width)
      draw.line(start_x, start_y, end_x, end_y)
      draw.pop
    end
  end
end

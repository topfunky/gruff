# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::DashLine
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs dasharray: Array[Float | Integer]
    # @rbs return: void
    def initialize(renderer, color:, width:, dasharray: [10, 20])
      @renderer = renderer
      @color = color
      @width = width
      @dasharray = dasharray
    end

    # @rbs start_x: Float | Integer
    # @rbs start_y: Float | Integer
    # @rbs end_x: Float | Integer
    # @rbs end_y: Float | Integer
    def render(start_x, start_y, end_x, end_y)
      @renderer.draw.push
      @renderer.draw.stroke_color(@color)
      @renderer.draw.stroke_dasharray(*@dasharray)
      @renderer.draw.stroke_width(@width)
      @renderer.draw.fill_opacity(0.0)
      @renderer.draw.line(start_x, start_y, end_x, end_y)
      @renderer.draw.pop
    end
  end
end

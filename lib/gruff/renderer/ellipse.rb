# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Ellipse
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs return: void
    def initialize(renderer, color:, width: 1.0)
      @renderer = renderer
      @color = color
      @width = width
    end

    # @rbs origin_x: Float | Integer
    # @rbs origin_y: Float | Integer
    # @rbs width: Float | Integer
    # @rbs height: Float | Integer
    # @rbs arc_start: Float | Integer
    # @rbs arc_end: Float | Integer
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

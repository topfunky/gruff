# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Circle
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs opacity: Float | Integer
    # @rbs return: void
    def initialize(renderer, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
    end

    # @rbs origin_x: Float | Integer
    # @rbs origin_y: Float | Integer
    # @rbs perim_x: Float | Integer
    # @rbs perim_y: Float | Integer
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

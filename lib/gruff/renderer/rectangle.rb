# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Rectangle
    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs opacity: Float | Integer
    # @rbs round: bool
    # @rbs return: void
    def initialize(renderer, color: nil, width: 1.0, opacity: 1.0, round: false)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
      @round = round
    end

    # @rbs upper_left_x: Float | Integer
    # @rbs upper_left_y: Float | Integer
    # @rbs lower_right_x: Float | Integer
    # @rbs lower_right_y: Float | Integer
    # @rbs return: void
    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      if @color
        @renderer.draw.stroke(@color) if @width > 1.0
        @renderer.draw.fill_opacity(@opacity)
        @renderer.draw.fill(@color)
      end

      if @round
        @renderer.draw.roundrectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y, 3, 3)
      else
        @renderer.draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      end
      @renderer.draw.pop
    end
  end
end

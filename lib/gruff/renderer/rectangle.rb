# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Rectangle
    def initialize(renderer, color: nil, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @color = color
      @width = width
      @opacity = opacity
    end

    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color) if @color && @width > 1.0
      @renderer.draw.fill_opacity(@opacity)
      @renderer.draw.fill(@color) if @color
      @renderer.draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      @renderer.draw.pop
    end
  end
end

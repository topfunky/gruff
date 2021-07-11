# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Rectangle
    def initialize(renderer, color: nil)
      @renderer = renderer
      @color = color
    end

    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      @renderer.draw.push
      @renderer.draw.stroke('transparent')
      @renderer.draw.fill(@color) if @color
      @renderer.draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      @renderer.draw.pop
    end
  end
end

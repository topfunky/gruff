# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Rectangle
    def initialize(color: nil)
      @color = color
    end

    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke('transparent')
      draw.fill(@color) if @color
      draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      draw.pop
    end
  end
end

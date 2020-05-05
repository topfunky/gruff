# frozen_string_literal: true

module Gruff
  class Renderer::Rectangle
    def initialize(args = {})
      @color = args[:color]
    end

    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      draw = Renderer.instance.draw

      draw.stroke('transparent')
      draw.fill(@color) if @color
      draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
    end
  end
end

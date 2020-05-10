# frozen_string_literal: true

module Gruff
  class Renderer::Rectangle
    def initialize(args = {})
      @color = args[:color]
      @antialias = args[:antialias].nil? ? true : args[:antialias]
    end

    def render(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      draw = Renderer.instance.draw

      draw.push
      draw.stroke_antialias(@antialias)
      draw.stroke('transparent')
      draw.fill(@color) if @color
      draw.rectangle(upper_left_x, upper_left_y, lower_right_x, lower_right_y)
      draw.pop
    end
  end
end

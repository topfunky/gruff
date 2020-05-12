# frozen_string_literal: true

module Gruff
  class Renderer::Dot
    def initialize(style, config)
      @style = style
      @color = config[:color]
      @width = config[:width] || 1.0
    end

    def render(new_x, new_y, circle_radius)
      draw = Renderer.instance.draw

      # draw.push # TODO
      draw.stroke_width(@width)
      draw.stroke(@color)
      draw.fill(@color)
      if @style.to_s == 'square'
        square(draw, new_x, new_y, circle_radius)
      else
        circle(draw, new_x, new_y, circle_radius)
      end
      # draw.pop # TODO
    end

    def circle(draw, new_x, new_y, circle_radius)
      draw.circle(new_x, new_y, new_x - circle_radius, new_y)
    end

    def square(draw, new_x, new_y, circle_radius)
      offset = (circle_radius * 0.8).to_i
      corner1 = new_x - offset
      corner2 = new_y - offset
      corner3 = new_x + offset
      corner4 = new_y + offset
      draw.rectangle(corner1, corner2, corner3, corner4)
    end
  end
end

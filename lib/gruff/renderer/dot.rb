# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Dot
    def initialize(renderer, style, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @style = style
      @color = color
      @width = width
      @opacity = opacity
    end

    def render(new_x, new_y, radius)
      # @renderer.draw.push # TODO
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill(@color)
      @renderer.draw.fill_opacity(@opacity)
      case @style.to_sym
      when :square
        square(new_x, new_y, radius)
      when :diamond
        diamond(new_x, new_y, radius)
      else
        circle(new_x, new_y, radius)
      end
      # @renderer.draw.pop # TODO
    end

    def circle(new_x, new_y, radius)
      @renderer.draw.circle(new_x, new_y, new_x - radius, new_y)
    end

    def square(new_x, new_y, radius)
      offset = (radius * 0.8).to_i
      corner1 = new_x - offset
      corner2 = new_y - offset
      corner3 = new_x + offset
      corner4 = new_y + offset
      @renderer.draw.rectangle(corner1, corner2, corner3, corner4)
    end

    def diamond(new_x, new_y, radius)
      offset = radius
      polygon = []
      polygon += [new_x - offset, new_y]
      polygon += [new_x, new_y + offset]
      polygon += [new_x + offset, new_y]
      polygon += [new_x, new_y - offset]
      @renderer.draw.polygon(*polygon)
    end
  end
end

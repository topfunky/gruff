# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Dot
    # @rbs renderer: Gruff::Renderer
    # @rbs style: :square | :circle | :diamond | 'square' | 'circle' | 'diamond'
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs opacity: Float | Integer
    # @rbs return: void
    def initialize(renderer, style, color:, width: 1.0, opacity: 1.0)
      @renderer = renderer
      @style = style.to_sym
      @color = color
      @width = width
      @opacity = opacity
    end

    # @rbs new_x: Float | Integer
    # @rbs new_y: Float | Integer
    # @rbs radius: Float | Integer
    def render(new_x, new_y, radius)
      @renderer.draw.push
      @renderer.draw.stroke_width(@width)
      @renderer.draw.stroke(@color)
      @renderer.draw.fill_opacity(@opacity)
      @renderer.draw.fill(@color)
      case @style
      when :square
        square(new_x, new_y, radius)
      when :diamond
        diamond(new_x, new_y, radius)
      else
        circle(new_x, new_y, radius)
      end
      @renderer.draw.pop
    end

  private

    def circle(new_x, new_y, radius)
      @renderer.draw.circle(new_x, new_y, new_x - radius, new_y)
    end

    def square(new_x, new_y, radius)
      corner1 = new_x - radius
      corner2 = new_y - radius
      corner3 = new_x + radius
      corner4 = new_y + radius
      @renderer.draw.rectangle(corner1, corner2, corner3, corner4)
    end

    def diamond(new_x, new_y, radius)
      polygon = []
      polygon += [new_x - radius, new_y]
      polygon += [new_x, new_y + radius]
      polygon += [new_x + radius, new_y]
      polygon += [new_x, new_y - radius]
      @renderer.draw.polygon(*polygon)
    end
  end
end

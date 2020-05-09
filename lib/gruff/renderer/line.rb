# frozen_string_literal: true

module Gruff
  class Renderer::Line
    EPSILON = 0.001

    def initialize(args = {})
      @color = args[:color]
      @width = args[:width]
      @antialias = args[:antialias] || false
    end

    def render(start_x, start_y, end_x, end_y)
      # FIXME(uwe): Workaround for Issue #66
      #             https://github.com/topfunky/gruff/issues/66
      #             https://github.com/rmagick/rmagick/issues/82
      #             Remove if the issue gets fixed.
      unless defined?(JRUBY_VERSION)
        start_x += EPSILON
        end_x += EPSILON
        start_y += EPSILON
        end_y += EPSILON
      end

      draw = Renderer.instance.draw

      draw.stroke_antialias(@antialias)

      if @width
        draw.stroke(@color)
        draw.stroke_width(@width)
      else
        draw.fill(@color)
        draw.stroke('transparent')
      end
      draw.line(start_x, start_y, end_x, end_y)

      draw.stroke_antialias(true) unless @antialias
    end
  end
end

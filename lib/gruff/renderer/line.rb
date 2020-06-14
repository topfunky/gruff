# frozen_string_literal: true

module Gruff
  class Renderer::Line
    EPSILON = 0.001

    def initialize(args = {})
      @color = args[:color]
      @shadow_color = args[:shadow_color]
      @width = args[:width]
    end

    def render(start_x, start_y, end_x, end_y)
      render_line(start_x, start_y, end_x, end_y, @color)
      render_line(start_x, start_y + 1, end_x, end_y + 1, @shadow_color) if @shadow_color
    end

  private

    def render_line(start_x, start_y, end_x, end_y, color)
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

      draw.push
      draw.stroke(color)
      draw.fill(color)
      draw.stroke_width(@width) if @width
      draw.line(start_x, start_y, end_x, end_y)
      draw.pop
    end
  end
end

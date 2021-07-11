# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Line
    EPSILON = 0.001

    def initialize(renderer, color:, width: nil, shadow_color: nil)
      @renderer = renderer
      @color = color
      @width = width
      @shadow_color = shadow_color
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

      @renderer.draw.push
      @renderer.draw.stroke(color)
      @renderer.draw.fill(color)
      @renderer.draw.stroke_width(@width) if @width
      @renderer.draw.line(start_x, start_y, end_x, end_y)
      @renderer.draw.pop
    end
  end
end

# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Line
    EPSILON = 0.001

    # @rbs renderer: Gruff::Renderer
    # @rbs color: String
    # @rbs width: Float | Integer
    # @rbs return: void
    def initialize(renderer, color:, width: nil)
      @renderer = renderer
      @color = color
      @width = width
    end

    # @rbs start_x: Float | Integer
    # @rbs start_y: Float | Integer
    # @rbs end_x: Float | Integer
    # @rbs end_y: Float | Integer
    def render(start_x, start_y, end_x, end_y)
      render_line(start_x, start_y, end_x, end_y, @color)
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
      @renderer.draw.stroke_width(@width) if @width
      @renderer.draw.stroke(color)
      @renderer.draw.fill(color)
      @renderer.draw.line(start_x, start_y, end_x, end_y)
      @renderer.draw.pop
    end
  end
end

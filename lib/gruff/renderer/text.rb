# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer::Text
    using Magick::GruffAnnotate

    # @rbs renderer: Gruff::Renderer
    # @rbs text: String
    # @rbs font: Gruff::Font
    # @rbs rotation: Float | Integer
    def initialize(renderer, text, font:, rotation: nil)
      @renderer = renderer
      @text = text.to_s
      @font = font
      @rotation = rotation
    end

    attr_reader :width, :height, :x, :y #: Float | Integer
    attr_reader :gravity

    # @rbs width: Float | Integer
    # @rbs height: Float | Integer
    # @rbs x: Float | Integer
    # @rbs y: Float | Integer
    # @rbs gravity: untyped
    def add_to_render_queue(width, height, x, y, gravity = Magick::NorthGravity)
      @width = width
      @height = height
      @x = x
      @y = y
      @gravity = gravity

      @renderer.text_renderers << self
    end

    # @rbs width: Float | Integer
    # @rbs height: Float | Integer
    # @rbs x: Float | Integer
    # @rbs y: Float | Integer
    # @rbs gravity: untyped
    def render(width, height, x, y, gravity = Magick::NorthGravity)
      @renderer.draw.push
      @renderer.draw.rotation = @rotation if @rotation
      @renderer.draw.fill = @font.color
      @renderer.draw.stroke = 'transparent'
      @renderer.draw.font = @font.file_path
      @renderer.draw.font_weight = @font.weight
      @renderer.draw.pointsize = @font.size * @renderer.scale
      @renderer.draw.gravity = gravity
      @renderer.draw.annotate_scaled(@renderer.image,
                                     width, height,
                                     x, y,
                                     @text, @renderer.scale)
      @renderer.draw.rotation = -@rotation if @rotation
      @renderer.draw.pop
    end

    def metrics
      @renderer.draw.push
      @renderer.draw.font = @font.file_path
      @renderer.draw.font_weight = @font.weight
      @renderer.draw.pointsize = @font.size

      # The old ImageMagick causes SEGV with string which has '%' + alphabet (eg. '%S').
      # This format is used to embed value into a string using image properties.
      # However, gruff use plain image as canvas which does not have any property.
      # So, in here, it just escape % in order to avoid SEGV.
      text = @text.to_s.gsub(/(%+)/) { ('%' * Regexp.last_match(1).size * 2).to_s } # steep:ignore

      metrics = @renderer.draw.get_type_metrics(@renderer.image, text)
      @renderer.draw.pop

      metrics
    end
  end
end

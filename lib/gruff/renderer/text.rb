# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Text
    using Magick::GruffAnnotate

    FONT_BOLD = File.expand_path(File.join(__FILE__, '../../../../assets/fonts/Roboto-Bold.ttf'))
    FONT_REGULAR = File.expand_path(File.join(__FILE__, '../../../../assets/fonts/Roboto-Regular.ttf'))

    def initialize(text, font:, size:, color:, weight: Magick::NormalWeight, rotation: nil)
      @text = text.to_s
      @font = font
      @font_size = size
      @font_color = color
      @font_weight = weight
      @rotation = rotation
    end

    attr_reader :width, :height, :x, :y, :gravity

    def add_to_render_queue(width, height, x, y, gravity = Magick::NorthGravity)
      @width = width
      @height = height
      @x = x
      @y = y
      @gravity = gravity

      Renderer.instance.text_renderers << self
    end

    def render(width, height, x, y, gravity = Magick::NorthGravity)
      draw  = Renderer.instance.draw
      image = Renderer.instance.image
      scale = Renderer.instance.scale

      draw.rotation = @rotation if @rotation
      draw.fill = @font_color
      draw.stroke = 'transparent'
      if @font
        draw.font = @font
      else
        draw.font = (@font_weight == Magick::BoldWeight) ? FONT_BOLD : FONT_REGULAR
      end
      draw.font_weight = @font_weight
      draw.pointsize = @font_size * scale
      draw.gravity = gravity
      draw.annotate_scaled(image,
                           width, height,
                           x, y,
                           @text, scale)
      draw.rotation = -@rotation if @rotation
    end

    def self.metrics(text, size, font_weight = Magick::NormalWeight)
      draw  = Renderer.instance.draw
      image = Renderer.instance.image

      draw.font_weight = font_weight
      draw.pointsize = size

      # The old ImageMagick causes SEGV with string which has '%' + alphabet (eg. '%S').
      # This format is used to embed value into a string using image properties.
      # However, gruff use plain image as canvas which does not have any property.
      # So, in here, it just escape % in order to avoid SEGV.
      text = text.to_s.gsub(/(%+)/) { ('%' * Regexp.last_match(1).size * 2).to_s }

      draw.get_type_metrics(image, text)
    end
  end
end

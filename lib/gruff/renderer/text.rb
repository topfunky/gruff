# frozen_string_literal: true

module Gruff
  # @private
  class Renderer::Text
    using Magick::GruffAnnotate

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
      draw.font = @font if @font
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
      draw.get_type_metrics(image, text.to_s)
    end
  end
end

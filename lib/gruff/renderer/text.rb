# frozen_string_literal: true

module Gruff
  class Renderer::Text
    def initialize(text, args = {})
      @text = text.to_s
      @font = args[:font]
      @font_size = args[:size]
      @font_color = args[:color]
      @font_weight = args[:weight] || Magick::NormalWeight
      @rotation = args[:rotation]
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
      draw = draw.annotate_scaled(image,
                                  width, height,
                                  x, y,
                                  @text, scale)
      draw.rotation = -@rotation if @rotation

      Renderer.instance.draw = draw
    end
  end
end

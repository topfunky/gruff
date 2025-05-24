# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Renderer
    attr_accessor :text_renderers #: Array[Gruff::Renderer::Text]
    attr_reader :draw
    attr_reader :image
    attr_reader :scale #: real

    # @rbs columns: Integer
    # @rbs rows: Integer
    # @rbs scale: Float | Integer
    # @rbs theme_options: ::Hash[Symbol, untyped]
    # @rbs return: void
    def initialize(columns, rows, scale, theme_options)
      @draw = Magick::Draw.new
      @text_renderers = []

      @scale = scale
      @draw.scale(scale, scale)
      @image = background(columns, rows, scale, theme_options)
    end

    def finish
      @draw.draw(@image)

      @text_renderers.each do |renderer|
        renderer.render(renderer.width, renderer.height, renderer.x, renderer.y, renderer.gravity)
      end
    end

    # @rbs columns: Integer
    # @rbs rows: Integer
    def transparent_background(columns, rows)
      @image = render_transparent_background(columns, rows)
    end

  private

    def background(columns, rows, scale, theme_options)
      return image_background(scale, *theme_options[:background_image]) if theme_options[:background_image] # steep:ignore

      case theme_options[:background_colors]
      when Array
        gradated_background(columns, rows, *theme_options[:background_colors][0..1], theme_options[:background_direction]) # steep:ignore
      when String
        solid_background(columns, rows, theme_options[:background_colors])
      else
        transparent_background(columns, rows)
      end
    end

    # Use with a theme to use an image (800x600 original) background.
    def image_background(scale, image_path)
      image = Magick::Image.read(image_path)
      if scale != 1.0
        image[0].resize!(scale) # TODO: Resize with new scale (crop if necessary for wide graph)
      end
      image[0]
    end

    # Make a new image at the current size with a solid +color+.
    def solid_background(columns, rows, color)
      Magick::Image.new(columns, rows) do |img|
        img.background_color = color
      end
    end

    # Use with a theme definition method to draw a gradated background.
    def gradated_background(columns, rows, top_color, bottom_color, direct = :top_bottom)
      gradient_fill = begin
        case direct
        when :bottom_top
          Magick::GradientFill.new(0, 0, 100, 0, bottom_color, top_color)
        when :left_right
          Magick::GradientFill.new(0, 0, 0, 100, top_color, bottom_color)
        when :right_left
          Magick::GradientFill.new(0, 0, 0, 100, bottom_color, top_color)
        when :topleft_bottomright
          Magick::GradientFill.new(0, 100, 100, 0, top_color, bottom_color)
        when :topright_bottomleft
          Magick::GradientFill.new(0, 0, 100, 100, bottom_color, top_color)
        else
          Magick::GradientFill.new(0, 0, 100, 0, top_color, bottom_color)
        end
      end

      image = Magick::Image.new(columns, rows, gradient_fill)
      @gradated_background_retry_count = 0

      image
    rescue StandardError => e
      @gradated_background_retry_count ||= 0
      GC.start

      if @gradated_background_retry_count < 3
        @gradated_background_retry_count += 1
        gradated_background(columns, rows, top_color, bottom_color, direct)
      else
        raise e
      end
    end

    # Use with a theme to make a transparent background
    def render_transparent_background(columns, rows)
      Magick::Image.new(columns, rows) do |img|
        img.background_color = 'transparent'
      end
    end
  end
end

# frozen_string_literal: true

require 'singleton'

module Gruff
  class Renderer
    include Singleton

    attr_accessor :draw, :image, :scale

    def self.background_image=(image)
      Renderer.instance.image = image
    end

    def self.finish
      draw  = Renderer.instance.draw
      image = Renderer.instance.image

      draw.draw(image)
    end

    def self.write(file_name)
      Renderer.instance.image.write(file_name)
    end

    def self.to_blob(file_format)
      Renderer.instance.image.to_blob do
        self.format = file_format
      end
    end
  end
end

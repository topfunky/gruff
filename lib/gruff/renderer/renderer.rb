# frozen_string_literal: true

require 'singleton'

module Gruff
  class Renderer
    include Singleton

    attr_accessor :draw, :image, :scale

    def self.finish
      draw  = Renderer.instance.draw
      image = Renderer.instance.image

      draw.draw(image)
    end
  end
end

# frozen_string_literal: true

require 'singleton'

module Gruff
  class Renderer
    include Singleton

    attr_accessor :draw, :image, :scale
  end
end

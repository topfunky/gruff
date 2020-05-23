# frozen_string_literal: true

module Gruff::Base::BarValueLabelMixin
  class BarValueLabel
    attr_accessor :coordinates, :values

    def initialize(size)
      @coordinates = Array.new(size)
      @values = Hash.new(0)
    end

    def prepare_rendering(format)
      @coordinates.each_with_index do |(left_x, left_y, right_x, _right_y), index|
        value = @values[index]
        val = (format || '%.2f') % value
        y = value >= 0 ? left_y - 30 : left_y + 12
        yield left_x + (right_x - left_x) / 2, y, val.commify
      end
    end
  end
end

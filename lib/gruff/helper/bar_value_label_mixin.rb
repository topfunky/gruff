# frozen_string_literal: true

module Gruff::Base::BarValueLabelMixin
  class BarValueLabel
    attr_accessor :coordinates, :values

    def initialize(size, bar_width)
      @coordinates = Array.new(size)
      @values = Hash.new(0)
      @bar_width = bar_width
    end

    def prepare_rendering(format)
      @coordinates.each_with_index do |(left_x, left_y, right_x, _right_y), index|
        value = @values[index]
        val = (format || '%.2f') % value
        y = value >= 0 ? left_y - 30 : left_y + 12
        yield left_x + (right_x - left_x) / 2, y, val.commify
      end
    end

    def prepare_sidebar_rendering(format)
      @coordinates.each_with_index do |(_left_x, _left_y, right_x, right_y), index|
        val = (format || '%.2f') % @values[index]
        yield right_x + 40, right_y - @bar_width / 2, val.commify
      end
    end
  end
end

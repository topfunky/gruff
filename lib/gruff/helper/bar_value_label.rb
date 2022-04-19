# frozen_string_literal: true

# @private
module Gruff::BarValueLabel
  using String::GruffCommify

  # @private
  class Base
    attr_reader :coordinate, :value

    def initialize(coordinate, value)
      @coordinate = coordinate
      @value = value
    end
  end

  # @private
  class Bar < Base
    def prepare_rendering(format, _bar_width = 0)
      left_x, left_y, right_x, _right_y = @coordinate
      val = begin
        if format.is_a?(Proc)
          format.call(@value)
        else
          sprintf(format || '%.2f', @value).commify
        end
      end

      y = @value >= 0 ? left_y - 30 : left_y + 12
      yield left_x + ((right_x - left_x) / 2), y, val
    end
  end

  # @private
  class SideBar < Base
    def prepare_rendering(format, bar_width = 0)
      left_x, _left_y, right_x, right_y = @coordinate
      val = begin
        if format.is_a?(Proc)
          format.call(@value)
        else
          sprintf(format || '%.2f', @value).commify
        end
      end
      x = @value >= 0 ? right_x + 40 : left_x - 40
      yield x, right_y - (bar_width / 2), val
    end
  end

  # @private
  class StackedBar
    def initialize
      @bars = []
    end

    def add(bar, index)
      bars = @bars[index] || []
      bars << bar
      @bars[index] = bars
    end

    def prepare_rendering(format, bar_width = 0, &block)
      @bars.each do |bars|
        value = bars.sum(&:value)
        bar = bars.last
        bar_value_label = bar.class.new(bar.coordinate, value)
        bar_value_label.prepare_rendering(format, bar_width, &block)
      end
    end
  end
end

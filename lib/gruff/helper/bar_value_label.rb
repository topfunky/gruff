# frozen_string_literal: true

# rbs_inline: enabled

# @private
module Gruff::BarValueLabel
  using String::GruffCommify

  # @private
  #
  # @rbs value: Float | Integer
  # @rbs format: nil | String | Proc
  # @rbs proc_text_metrics: Proc
  # @rbs return: [String, untyped]
  # TODO: Fix the return type
  def self.metrics(value, format, proc_text_metrics)
    val = begin
      if format.is_a?(Proc)
        format.call(value)
      else
        sprintf(format || '%.2f', value).commify # steep:ignore
      end
    end

    metrics = proc_text_metrics.call(val)
    [val, metrics]
  end

  # @private
  class Base
    attr_reader :coordinate #: [Float | Integer, Float | Integer, Float | Integer, Float | Integer]
    attr_reader :value #: Float | Integer

    # @rbs coordinate: [nil | Float | Integer, nil | Float | Integer, nil | Float | Integer, nil | Float | Integer]
    # @rbs value: Float | Integer
    # @rbs return: void
    def initialize(coordinate, value)
      @coordinate = coordinate
      @value = value
    end
  end

  # @private
  class Bar < Base
    # @rbs format: nil | String | Proc
    # @rbs proc_text_metrics: Proc
    # @rbs yields: (Float | Integer, Float | Integer, String, Float, Float) -> void
    def prepare_rendering(format, proc_text_metrics)
      left_x, left_y, _right_x, _right_y = @coordinate
      val, metrics = Gruff::BarValueLabel.metrics(@value, format, proc_text_metrics)

      y = @value >= 0 ? left_y - metrics.height - 5 : left_y + 5 #: Float
      yield left_x, y, val, metrics.width, metrics.height
    end
  end

  # @private
  class SideBar < Base
    # @rbs format: nil | String | Proc
    # @rbs proc_text_metrics: Proc
    # @rbs yields: (Float | Integer, Float | Integer, String, Float, Float) -> void
    def prepare_rendering(format, proc_text_metrics)
      left_x, left_y, right_x, _right_y = @coordinate
      val, metrics = Gruff::BarValueLabel.metrics(@value, format, proc_text_metrics)

      x = @value >= 0 ? right_x + 10 : left_x - metrics.width - 10 #: Float
      yield x, left_y, val, metrics.width, metrics.height
    end
  end
end

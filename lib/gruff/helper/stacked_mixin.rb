# frozen_string_literal: true

# rbs_inline: enabled

# @private
module Gruff::Base::StackedMixin
  # Used by StackedBar and child classes.
  #
  # tsal: moved from Base 03 FEB 2007
  def calculate_maximum_by_stack
    # steep:ignore:start
    # Get sum of each stack
    max_hash = Hash.new { |h, k| h[k] = 0.0 }
    store.data.each do |data_set|
      data_set.points.each_with_index do |data_point, i|
        max_hash[i] += data_point.to_f
      end
    end

    max_hash.each_key do |key|
      self.maximum_value = max_hash[key] if max_hash[key] > maximum_value
      self.minimum_value = max_hash[key] if max_hash[key] < minimum_value
    end

    raise "Can't handle negative values in stacked graph" if minimum_value < 0
    # steep:ignore:end
  end

  # @rbs return: Array[Array[Gruff::Base::StackedMixin::BarData]]
  def normalized_stacked_bars
    # steep:ignore:start
    @normalized_stacked_bars ||= begin
      stacked_bars = Array.new(column_count) { [] }
      store.norm_data.each_with_index do |data_row, row_index|
        data_row.points.each_with_index do |data_point, point_index|
          stacked_bars[point_index] << BarData.new(data_point, store.data[row_index].points[point_index], data_row.color)
        end
      end
      stacked_bars
    end
    # steep:ignore:end
  end

  # @private
  class BarData
    attr_accessor :point #: Float | Integer
    attr_accessor :value #: Float | Integer
    attr_accessor :color #: String

    # @rbs point: Float | Integer
    # @rbs value: Float | Integer
    # @rbs color: String
    # @rbs return: void
    def initialize(point, value, color)
      @point = point
      @value = value
      @color = color
    end
  end
end

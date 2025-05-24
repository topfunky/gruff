# frozen_string_literal: true

# rbs_inline: enabled

# @private
module Gruff::Base::BarMixin
  # @rbs return: Array[Array[Gruff::Base::BarMixin::BarData]]
  def normalized_group_bars
    # steep:ignore:start
    @normalized_group_bars ||= begin
      group_bars = Array.new(column_count) { [] }
      store.norm_data.each_with_index do |data_row, row_index|
        data_row.points.each_with_index do |data_point, point_index|
          group_bars[point_index] << BarData.new(data_point, store.data[row_index].points[point_index], data_row.color)
        end

        # Adjust the number of each group with empty bar
        (data_row.points.size..(column_count - 1)).each do |index|
          group_bars[index] << BarData.new(0, nil, data_row.color)
        end
      end
      group_bars
    end
    # steep:ignore:end
  end

  # @private
  class BarData
    attr_accessor :point #: Float | Integer
    attr_accessor :value #: nil | Float | Integer
    attr_accessor :color #: String

    # @rbs point: Float | Integer
    # @rbs value: nil | Float | Integer
    # @rbs color: String
    # @rbs return: void
    def initialize(point, value, color)
      @point = point
      @value = value
      @color = color
    end
  end
end

# frozen_string_literal: true

# @private
module Gruff::Base::BarMixin
  def normalized_group_bars
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
  end

  # @private
  class BarData < Struct.new(:point, :value, :color)
  end
end

# frozen_string_literal: true

# @private
module Gruff::Base::StackedMixin
  # Used by StackedBar and child classes.
  #
  # tsal: moved from Base 03 FEB 2007
  def calculate_maximum_by_stack
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
  end
end

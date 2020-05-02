# frozen_string_literal: true

module Gruff::Base::StackedMixin
  # Used by StackedBar and child classes.
  #
  # tsal: moved from Base 03 FEB 2007
  def get_maximum_by_stack
    # Get sum of each stack
    max_hash = {}
    store.data.each do |data_set|
      data_set.points.each_with_index do |data_point, i|
        max_hash[i] = 0.0 unless max_hash[i]
        max_hash[i] += data_point.to_f
      end
    end

    max_hash.each_key do |key|
      self.maximum_value = max_hash[key] if max_hash[key] > maximum_value
    end
    self.minimum_value = 0
  end
end

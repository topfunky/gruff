
module Gruff::Base::StackedMixin
  # Used by StackedBar and child classes.
  #
  # tsal: moved from Base 03 FEB 2007
  DATA_VALUES_INDEX = Gruff::Base::DATA_VALUES_INDEX
  def get_maximum_by_stack
    # Get sum of each stack
    max_hash = {}
    @data.each do |data_set|
      data_set[DATA_VALUES_INDEX].each_with_index do |data_point, i|
        max_hash[i] = 0.0 unless max_hash[i]
        max_hash[i] += data_point.to_f
      end
    end

    # @maximum_value = 0
    max_hash.keys.each do |key|
      @maximum_value = max_hash[key] if max_hash[key] > @maximum_value
    end
    @minimum_value = 0
  end
end

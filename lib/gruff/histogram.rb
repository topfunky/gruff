# frozen_string_literal: true

require 'histogram'
require 'gruff/base'

#
# Here's how to set up a Gruff::Histogram.
#
#   g = Gruff::Histogram.new
#   g.title = 'Histogram Graph'
#   g.minimum_bin = 10
#   g.bin_width = 20
#   g.data :A, [10, 10, 20, 30, 40, 40, 40, 40, 40, 40, 50, 10, 10, 10]
#   g.data :B, [100, 100, 100, 100, 90, 90, 80, 30, 30, 30, 30, 30]
#   g.write('histogram.png')
#
class Gruff::Histogram < Gruff::Bar
  def initialize_ivars
    super
    @bin_width = 10
    @minimum_bin = nil
    @maximum_bin = nil
  end
  private :initialize_ivars

  # Specifies interpolation between the min and max of the set. Default is +10+.
  def bin_width=(width)
    raise 'bin_width= should be called before set the data.' unless store.empty?

    @bin_width = width
  end

  # Specifies minimum value for bin.
  def minimum_bin=(min)
    raise 'minimum_bin= should be called before set the data.' unless store.empty?

    @minimum_bin = min
  end

  # Specifies maximum value for bin.
  def maximum_bin=(max)
    raise 'maximum_bin= should be called before set the data.' unless store.empty?

    @maximum_bin = max
  end

  def data(name, data_points = [], color = nil)
    bins, freqs = HistogramArray.new(data_points).histogram(bin_width: @bin_width, min: @minimum_bin, max: @maximum_bin)
    bins.each_with_index do |bin, index|
      labels[index] = bin
    end
    store.add(name, freqs, color)
  end

  # @private
  class HistogramArray < Array
    include ::Histogram
  end
end

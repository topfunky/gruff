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
    @minimum_bin = 0
  end
  private :initialize_ivars

  # Specifies interpolation between the min and max of the set. Default is +10+.
  def bin_width=(width)
    raise 'bin_width= should be called before set the data.' unless store.empty?

    @bin_width = width
  end

  # Specifies minimum value for bin. Default is +0+.
  def minimum_bin=(bin)
    raise 'minimum_bin= should be called before set the data.' unless store.empty?

    @minimum_bin = bin
  end

  def data(name, data_points = [], color = nil)
    bins, freqs = HistogramArray.new(data_points).histogram(bin_width: @bin_width, min: @minimum_bin)
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

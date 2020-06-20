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
  # Specifies interpolation between the min and max of the set. Default is +10+.
  attr_writer :bin_width

  # Specifies minimum value for bin.
  attr_writer :minimum_bin

  # Specifies maximum value for bin.
  attr_writer :maximum_bin

  def initialize(*)
    super
    @data = []
  end

  def initialize_ivars
    super
    @bin_width = 10
    @minimum_bin = nil
    @maximum_bin = nil
  end
  private :initialize_ivars

  def data(name, data_points = [], color = nil)
    @data << [name, data_points, color]
  end

  def draw
    @data.each do |(name, data_points, color)|
      bins, freqs = HistogramArray.new(data_points).histogram(bin_width: @bin_width, min: @minimum_bin, max: @maximum_bin)
      bins.each_with_index do |bin, index|
        @labels[index] = bin
      end
      store.add(name, freqs, color)
    end

    super
  end

  # @private
  class HistogramArray < Array
    include ::Histogram
  end
end

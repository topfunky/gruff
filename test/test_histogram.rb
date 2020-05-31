# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffHistogram < GruffTestCase
  def test_histogram_graph
    g = Gruff::Histogram.new
    g.title = 'Histogram Graph'
    g.data :A, [10, 10, 20, 30, 40, 40, 40, 40, 40, 40, 50, 10, 10, 10]
    g.data :B, [100, 100, 100, 100, 90, 90, 80, 30, 30, 30, 30, 30]
    g.write('test/output/histogram.png')
    assert_same_image('test/expected/histogram.png', 'test/output/histogram.png')
  end

  def test_histogram_minimum_maximum
    g = Gruff::Histogram.new
    g.title = 'Histogram Graph'
    g.minimum_bin = 10
    g.maximum_bin = 90
    g.bin_width = 20
    g.data :A, [10, 10, 20, 30, 40, 40, 40, 40, 40, 40, 50, 10, 10, 10]
    g.data :B, [100, 100, 100, 100, 90, 90, 80, 30, 30, 30, 30, 30]
    g.write('test/output/histogram_minmax.png')
    assert_same_image('test/expected/histogram_minmax.png', 'test/output/histogram_minmax.png')
  end
end

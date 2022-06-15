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

  def test_bin_width_after_data_method
    g = Gruff::Histogram.new
    g.title = 'Histogram Graph'
    g.minimum_bin = 10
    g.maximum_bin = 90
    g.data :A, [10, 10, 20, 30, 40, 40, 40, 40, 40, 40, 50, 10, 10, 10]
    g.data :B, [100, 100, 100, 100, 90, 90, 80, 30, 30, 30, 30, 30]
    g.bin_width = 20
    g.write('test/output/histogram_bin_width_after_data_method.png')
    assert_same_image('test/expected/histogram_bin_width_after_data_method.png', 'test/output/histogram_bin_width_after_data_method.png')
  end

  def test_empty_data
    g = Gruff::Histogram.new
    g.title = 'Contained Empty Data'
    g.data :A, []
    g.data :B, [100, 100, 100, 100, 90, 90, 80, 30, 30, 30, 30, 30]
    g.data :C, nil

    g.write('test/output/histogram_empty_data.png')
    assert_same_image('test/expected/histogram_empty_data.png', 'test/output/histogram_empty_data.png')
  end

  def test_duck_typing
    g = Gruff::Histogram.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/histogram_duck_typing.png')
    assert_same_image('test/expected/histogram_duck_typing.png', 'test/output/histogram_duck_typing.png')
  end
end

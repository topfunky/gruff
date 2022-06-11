# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestCandlestick < GruffTestCase
  def test_candlestick
    g = setup_basic_graph
    g.write('test/output/candlestick.png')
    assert_same_image('test/expected/candlestick.png', 'test/output/candlestick.png')
  end

  def test_candlestick_spacing_factor
    g = setup_basic_graph
    g.spacing_factor = 0.25
    g.write('test/output/candlestick_spacing_factor.png')
    assert_same_image('test/expected/candlestick_spacing_factor.png', 'test/output/candlestick_spacing_factor.png')
  end

  def test_candlestick_show_vertical_markers
    g = setup_basic_graph
    g.show_vertical_markers = true
    g.write('test/output/candlestick_show_vertical_markers.png')
    assert_same_image('test/expected/candlestick_show_vertical_markers.png', 'test/output/candlestick_show_vertical_markers.png')
  end

  def test_sort
    g = setup_basic_graph
    assert_raises(RuntimeError) do
      g.sort = true
    end
    assert_raises(RuntimeError) do
      g.sorted_drawing = true
    end
  end

private

  def setup_basic_graph(size = 800)
    g = Gruff::Candlestick.new(size)
    g.title = 'AAPL'
    g.data low: 79.30, high: 93.10, open: 79.44, close: 91.20
    g.data low: 89.14, high: 106.42, open: 91.28, close: 106.26
    g.data low: 107.89, high: 131.00, open: 108.20, close: 129.04
    g.data low: 103.10, high: 137.98, open: 132.76, close: 115.81
    g.data low: 107.72, high: 125.39, open: 117.64, close: 108.86
    g.data low: 107.32, high: 121.99, open: 109.11, close: 119.05
    g.data low: 120.01, high: 138.79, open: 121.01, close: 132.69
    g.data low: 126.38, high: 145.09, open: 133.52, close: 131.96
    g.data low: 118.39, high: 137.88, open: 133.75, close: 121.26
    g.data low: 116.21, high: 128.72, open: 123.75, close: 122.15
    g.data low: 122.49, high: 137.07, open: 123.66, close: 131.46
    g.data low: 122.25, high: 134.07, open: 132.04, close: 124.61
    g.data low: 123.13, high: 137.41, open: 125.08, close: 136.96
    g.data low: 135.76, high: 150.00, open: 136.60, close: 145.86
    g.data low: 144.50, high: 153.49, open: 146.36, close: 151.83
    g.data low: 141.27, high: 157.26, open: 152.83, close: 141.50
    g.data low: 138.27, high: 153.16, open: 141.90, close: 149.80
    g.data low: 147.48, high: 165.70, open: 148.99, close: 165.30
    g.data low: 157.80, high: 182.13, open: 167.48, close: 177.57
    g.data low: 154.70, high: 182.94, open: 177.83, close: 174.78
    g.data low: 152.00, high: 176.65, open: 174.01, close: 165.12
    g.data low: 150.10, high: 179.61, open: 164.70, close: 174.61
    g.data low: 155.39, high: 178.47, open: 174.03, close: 157.65
    g.data low: 154.66, high: 158.00, open: 156.82, close: 155.96
    g.labels = {
      0 => '2020/06',
      4 => '2020/10',
      8 => '2021/02',
      12 => '2021/06',
      16 => '2021/10',
      20 => '2022/02'
    }
    g
  end
end

# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestBoxPlot < GruffTestCase
  def test_box_plot
    g = Gruff::BoxPlot.new
    g.theme_pastel
    g.title = 'Box Plot Sample'
    g.data 'A', [2, 3, 5, 6, 8, 10, 11, 15, 17, 20, 28, 29, 33, 34, 45, 46, 49, 61]
    g.data 'B', [3, 4, 34, 35, 38, 39, 45, 60, 61, 69, 80, 130]
    g.data 'C', [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99, 153]
    g.y_axis_increment = 20
    g.x_axis_label = 'X Axis'
    g.y_axis_label = 'Y Axis'

    g.write('test/output/box_plot.png')
    assert_same_image('test/expected/box_plot.png', 'test/output/box_plot.png')
  end
end

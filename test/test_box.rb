# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestBox < GruffTestCase
  def test_box
    g = Gruff::Box.new
    g.theme_pastel
    g.title = 'Box Plot Sample'
    g.data 'A', [2, 3, 5, 6, 8, 10, 11, 15, 17, 20, 28, 29, 33, 34, 45, 46, 49, 61]
    g.data 'B', [3, 4, 34, 35, 38, 39, 45, 60, 61, 69, 80, 130]
    g.data 'C', [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99, 153]
    g.y_axis_increment = 20
    g.x_axis_label = 'X Axis'
    g.y_axis_label = 'Y Axis'

    g.write('test/output/box.png')

    assert_same_image('test/expected/box.png', 'test/output/box.png')
  end

  def test_box_spacing_factor
    skip 'This spec fails on ARM platform' if arm_platform?

    g = Gruff::Box.new
    g.theme_pastel
    g.title = 'Box Plot spacing_factor'
    g.data 'A', [2, 3, 5, 6, 8, 10, 11, 15, 17, 20, 28, 29, 33, 34, 45, 46, 49, 61]
    g.data 'B', [3, 4, 34, 35, 38, 39, 45, 60, 61, 69, 80, 130]
    g.data 'C', [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99, 153]
    g.y_axis_increment = 20
    g.spacing_factor = 0.25

    g.write('test/output/box_spacing_factor.png')

    assert_same_image('test/expected/box_spacing_factor.png', 'test/output/box_spacing_factor.png')
  end

  def test_box_outliers
    skip 'This spec fails on ARM platform' if arm_platform?

    g = Gruff::Box.new
    g.theme_pastel
    g.title = 'Box Plot Sample'
    g.data 'A', [34, 35, 38, 39, 45, 60, 61, 69, 80, 130]
    g.data 'B', [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99]
    g.data 'C', [41, 38, 47, 38, 50, 59, 56, 50, 62, 74, 41, 50, 59, 95, 50, 56, 47, 44, 65, 59, 50, 80]
    g.data 'D', [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99, 153, 38, 47, 38, 50, 59, 56, 50, 62, 74, 41, 50, 59, 95, 50, 56, 47, 44, 65, 59, 50, 80]
    g.write('test/output/box_outliers.png')

    assert_same_image('test/expected/box_outliers.png', 'test/output/box_outliers.png')
  end

  def test_empty_data
    skip 'This spec fails on ARM platform' if arm_platform?

    g = Gruff::Box.new
    g.title = 'Contained Empty Data'
    g.data 'A', []
    g.data 'B', [41, 38, 47, 38, 50, 59, 56, 50, 62, 74, 41, 50, 59, 95, 50, 56, 47, 44, 65, 59, 50, 80]
    g.data 'C', nil

    g.write('test/output/box_empty_data.png')

    assert_same_image('test/expected/box_empty_data.png', 'test/output/box_empty_data.png')
  end
end

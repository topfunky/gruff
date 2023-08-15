# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffBase < GruffTestCase
  def setup
    @sample_numeric_labels = {
      0 => 6,
      1 => 15,
      2 => 24,
      3 => 30,
      4 => 4,
      5 => 12,
      6 => 21,
      7 => 28
    }
  end

  def test_labels_can_be_any_object
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors'
    g.legend_margin = 50
    g.labels = @sample_numeric_labels
    g.data(:Art, [0, 5, 8, 15], '#990000')
    g.data(:Philosophy, [10, 3, 2, 8], '#009900')
    g.data(:Science, [2, 15, 8, 11], '#990099')

    g.minimum_value = 0

    g.write('test/output/base_object_labels.png')

    assert_same_image('test/expected/base_object_labels.png', 'test/output/base_object_labels.png')
  end

  def test_font
    g = Gruff::Bar.new
    g.title_font = File.join(fixtures_dir, 'Pacifico-Regular.ttf')
    g.font = File.join(fixtures_dir, 'ComicNeue-Regular.ttf')
    g.title = 'Bar Graph With Manual Colors'
    g.data('Hello world!!!', [0, 5, 8, 15], '#990000')
    g.write('test/output/base_font.png')

    assert_same_image('test/expected/base_font.png', 'test/output/base_font.png')
  end

  def test_empty_title
    g = Gruff::Bar.new
    g.title = ''
    g.data('foo', [0, 5, 8, 15])
    g.draw

    g = Gruff::Bar.new
    g.title = nil
    g.data('foo', [0, 5, 8, 15])
    g.draw

    pass
  end

  def test_multi_line_title
    g = Gruff::Bar.new
    g.title = ['Bar Graph', 'With Manual Colors']
    g.data('foo', [0, 5, 8, 15])
    g.write('test/output/base_multi_line_title.png')

    assert_same_image('test/expected/base_multi_line_title.png', 'test/output/base_multi_line_title.png')
  end

  def test_bold_title
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors'
    g.bold_title = true
    g.data('foo', [0, 5, 8, 15])
    g.write('test/output/base_bold_title.png')

    assert_same_image('test/expected/base_bold_title.png', 'test/output/base_bold_title.png')
  end

  def test_title_font_size
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors' * 2
    g.data('foo', [0, 5, 8, 15])
    g.write('test/output/base_title_font_size.png')

    assert_same_image('test/expected/base_title_font_size.png', 'test/output/base_title_font_size.png')
  end

  def test_legend_with_no_name
    g = Gruff::Bar.new
    g.data nil, [1, 2, 3, 4, 5]
    g.data 'foo', [6, 7, 8, 9, 10]
    g.data '', [10, 5, 4, 7, 2]
    g.write('test/output/base_legend_with_no_name.png')

    assert_same_image('test/expected/base_legend_with_no_name.png', 'test/output/base_legend_with_no_name.png')
  end

  def test_margins
    g = Gruff::Bar.new
    g.margins = 40.0
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Vincent, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Jake, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Stephen, [5, 10, 13, 11, 6, 16, 22, 32]
    g.write('test/output/base_margins.png')

    assert_same_image('test/expected/base_margins.png', 'test/output/base_margins.png')
  end

  def test_attribute_margins
    g = Gruff::Bar.new
    g.title = 'Bar Graph'
    g.label_margin = 30.0
    g.top_margin = 10.0
    g.bottom_margin = 5.0
    g.right_margin = 5.0
    g.left_margin = 5.0
    g.title_margin = 10.0
    g.legend_margin = 5.0

    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Vincent, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Jake, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Stephen, [5, 10, 13, 11, 6, 16, 22, 32]
    g.write('test/output/base_attribute_margins.png')

    assert_same_image('test/expected/base_attribute_margins.png', 'test/output/base_attribute_margins.png')
  end

  def test_add_color
    g = Gruff::Bar.new
    g.add_color '#990000'
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Vincent, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Jake, [5, 10, 13, 11, 6, 16, 22, 32]
    g.data :Stephen, [5, 10, 13, 11, 6, 16, 22, 32]
    g.write('test/output/base_add_color.png')

    assert_same_image('test/expected/base_add_color.png', 'test/output/base_add_color.png')
  end

  def test_data_given
    graph = Gruff::Bar.new

    refute(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]

    assert(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]
    graph.minimum_value = 10
    graph.maximum_value = -10

    refute(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]
    graph.minimum_value = 0
    graph.maximum_value = 5

    assert(graph.__send__(:data_given?))
  end

  def test_minimum
    g = Gruff::Bar.new
    g.minimum_value = 3
    g.data :foo, [1, 2, 3, 4, 5]
    g.data :bar, [6, 7, 8, 9, 10]

    assert_equal(3, g.minimum_value)
    assert_equal(10, g.maximum_value)

    g = Gruff::Bar.new
    g.data :foo, [1, 2, 3, 4, 5]
    g.data :bar, [6, 7, 8, 9, 10]
    g.minimum_value = 3

    assert_equal(3, g.minimum_value)
    assert_equal(10, g.maximum_value)
  end

  def test_maximum
    g = Gruff::Bar.new
    g.maximum_value = 3
    g.data :bar, [6, 7, 8, 9, 10]
    g.data :foo, [1, 2, 3, 4, 5]

    assert_equal(0, g.minimum_value)
    assert_equal(3, g.maximum_value)

    g = Gruff::Bar.new
    g.data :bar, [6, 7, 8, 9, 10]
    g.data :foo, [1, 2, 3, 4, 5]
    g.maximum_value = 3

    assert_equal(0, g.minimum_value)
    assert_equal(3, g.maximum_value)
  end

  def test_labels_with_array
    g = Gruff::Bar.new
    g.data :bar, [6, 7, 8, 9, 10]
    g.data :foo, [1, 2, 3, 4, 5]
    g.labels = [
      '2022-01-01',
      nil,
      '2022-03-01',
      ''
    ]
    g.write('test/output/base_labels_with_array.png')

    assert_same_image('test/expected/base_labels_with_array.png', 'test/output/base_labels_with_array.png')
  end

  def test_to_image
    g = Gruff::Bar.new
    g.data :bar, [6, 7, 8, 9, 10]

    assert_kind_of(Magick::Image, g.to_image)
    assert_kind_of(String, g.to_image.to_blob)
  end

  def test_to_blob
    g = Gruff::Bar.new
    g.data :bar, [6, 7, 8, 9, 10]

    assert_kind_of(String, g.to_blob)
  end

  def test_label_rotation_1
    g = Gruff::Line.new
    g.data 'Apples', [1, 2, 3, 4]
    g.data 'Oranges', [4, 8, 7, 9]
    g.data 'Watermelon', [2, 3, 1, 5]
    g.data 'Peaches', [9, 9, 10, 8]
    g.labels = [
      'a' * 10,
      'b' * 10,
      'c' * 10,
      'd' * 10
    ]
    g.label_rotation = -30
    g.write('test/output/base_label_rotation_1.png')

    assert_same_image('test/expected/base_label_rotation_1.png', 'test/output/base_label_rotation_1.png')
  end

  def test_label_rotation_2
    g = Gruff::Line.new
    g.data 'Apples', [1, 2, 3, 4]
    g.data 'Oranges', [4, 8, 7, 9]
    g.data 'Watermelon', [2, 3, 1, 5]
    g.data 'Peaches', [9, 9, 10, 8]
    g.labels = [
      'a' * 10,
      'b' * 10,
      'c' * 10,
      'd' * 10
    ]
    g.label_rotation = 30
    g.write('test/output/base_label_rotation_2.png')

    assert_same_image('test/expected/base_label_rotation_2.png', 'test/output/base_label_rotation_2.png')
  end

  def test_label_rotation_legend_at_bottom_xy_axis_label
    g = Gruff::Line.new
    g.data 'Apples', [1, 2, 3, 4]
    g.data 'Oranges', [4, 8, 7, 9]
    g.data 'Watermelon', [2, 3, 1, 5]
    g.data 'Peaches', [9, 9, 10, 8]
    g.labels = [
      'a' * 10,
      'b' * 10,
      'c' * 10,
      'd' * 10
    ]
    g.label_rotation = -30
    g.legend_at_bottom = true
    g.x_axis_label = 'a' * 20
    g.y_axis_label = 'b' * 20
    g.write('test/output/base_label_rotation_legend_at_bottom_xy_axis_label.png')

    assert_same_image('test/expected/base_label_rotation_legend_at_bottom_xy_axis_label.png',
                      'test/output/base_label_rotation_legend_at_bottom_xy_axis_label.png')
  end
end

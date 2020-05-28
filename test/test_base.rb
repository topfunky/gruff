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

    g.write('test/output/bar_object_labels.png')
    assert_same_image('test/expected/bar_object_labels.png', 'test/output/bar_object_labels.png')
  end

  def test_font
    g = Gruff::Bar.new
    g.title_font = File.join(fixtures_dir, 'Pacifico-Regular.ttf')
    g.font = File.join(fixtures_dir, 'ComicNeue-Regular.ttf')
    g.title = 'Bar Graph With Manual Colors'
    g.data('Hello world!!!', [0, 5, 8, 15], '#990000')
    g.write('test/output/bar_font.png')
    assert_same_image('test/expected/bar_font.png', 'test/output/bar_font.png')
  end

  def test_title_font_size
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors' * 2
    g.data('foo', [0, 5, 8, 15])
    g.write('test/output/bar_title_font_size.png')
    assert_same_image('test/expected/bar_title_font_size.png', 'test/output/bar_title_font_size.png')
  end

  def test_legend_with_no_name
    g = Gruff::Bar.new
    g.data nil, [1, 2, 3, 4, 5]
    g.data 'foo', [6, 7, 8, 9, 10]
    g.data '', [10, 5, 4, 7, 2]
    g.write('test/output/legend_with_no_name.png')
    assert_same_image('test/expected/legend_with_no_name.png', 'test/output/legend_with_no_name.png')
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
    assert_equal(1, g.minimum_value)
    assert_equal(3, g.maximum_value)

    g = Gruff::Bar.new
    g.data :bar, [6, 7, 8, 9, 10]
    g.data :foo, [1, 2, 3, 4, 5]
    g.maximum_value = 3
    assert_equal(1, g.minimum_value)
    assert_equal(3, g.maximum_value)
  end
end

# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffScatter < Minitest::Test
  def setup
    @datasets = [
      [:Chuck, [20, 10, 5, 12, 11, 6, 10, 7], [5, 10, 19, 6, 9, 1, 14, 8]],
      [:Brown, [5, 10, 20, 6, 9, 12, 14, 8], [20, 10, 5, 12, 11, 6, 10, 7]],
      [:Lucy, [19, 9, 6, 11, 12, 7, 15, 8], [6, 11, 18, 8, 12, 8, 10, 6]]
    ]
  end

  def test_scatter_graph
    g = setup_basic_graph
    g.title = 'Basic Scatter Plot Test'
    g.write('test/output/scatter_basic.png')
    assert_same_image('test/expected/scatter_basic.png', 'test/output/scatter_basic.png')
  end

  def test_many_datapoints
    srand 135
    g = Gruff::Scatter.new
    g.title = 'Many Datapoint Graph Test'
    y_values = (0..50).map { rand(100) }
    x_values = (0..50).map { rand(100) }
    g.data('many points', x_values, y_values)

    # Default theme
    g.write('test/output/scatter_many.png')
    assert_same_image('test/expected/scatter_many.png', 'test/output/scatter_many.png')
  end

  def test_custom_label_format
    g = Gruff::Scatter.new('1000x500')
    g.top_margin = 0
    g.hide_legend = true
    g.hide_title = true
    g.marker_font_size = 9
    g.theme = {
      colors: %w[#12a702 #aedaa9],
      marker_color: '#dddddd',
      font_color: 'black',
      background_colors: 'white'
    }

    # Points style
    g.circle_radius = 1
    g.stroke_width = 0.01

    # Axis labels
    g.x_label_margin = 25
    g.bottom_margin = 60
    g.disable_significant_rounding_x_axis = true
    g.use_vertical_x_labels = true
    g.label_rotation = -45
    g.enable_vertical_line_markers = true
    g.marker_x_count = 50 # One label every 2 days
    g.x_axis_label_format = lambda do |value|
      Time.at(value).strftime('%d.%m.%Y')
    end
    g.y_axis_increment = 1
    g.y_axis_label_format = lambda do |value|
      sprintf('%.1f', value)
    end

    # Fake data (100 days, random times of day between 5 and 16)
    srand 872
    r = Random.new(269_155)
    time = Time.mktime(2000, 1, 1)
    y_values = (0..100).map { 5 + r.rand(12) }
    x_values = (0..100).map { |i| time.to_i + (i * 3600 * 24) }
    g.data('many points', x_values, y_values)
    g.write('test/output/scatter_custom_label_format.png')
    assert_same_image('test/expected/scatter_custom_label_format.png', 'test/output/scatter_custom_label_format.png')
  end

  def test_no_data
    g = Gruff::Scatter.new(400)
    g.title = 'No Data'
    # Default theme
    g.write('test/output/scatter_no_data.png')
    assert_same_image('test/expected/scatter_no_data.png', 'test/output/scatter_no_data.png')

    g = Gruff::Scatter.new(400)
    g.title = 'No Data Title'
    g.no_data_message = 'There is no data'
    g.write('test/output/scatter_no_data_msg.png')
    assert_same_image('test/expected/scatter_no_data_msg.png', 'test/output/scatter_no_data_msg.png')
  end

  def test_all_zeros
    g = Gruff::Scatter.new(400)
    g.title = 'All Zeros'

    g.data(:gus, [0, 0, 0, 0], [0, 0, 0, 0])

    # Default theme
    g.write('test/output/scatter_no_data_other.png')
    assert_same_image('test/expected/scatter_no_data_other.png', 'test/output/scatter_no_data_other.png')
  end

  def test_some_nil_points
    g = Gruff::Scatter.new
    g.title = 'Some Nil Points'

    @datasets = [
      [:data1, [1, 2, 3, nil, 3, 5, 6], [5, nil, nil, nil, nil, 5, 7]]
    ]

    @datasets.each do |data|
      assert_raises ArgumentError do
        g.data(*data)
      end
    end
  end

  def test_unequal_number_of_x_and_y_values
    g = Gruff::Scatter.new
    g.title = 'Unequal number of X and Y values'

    @datasets = [
      [:data1, [1, 2, 3], [1, 2]],
      [:data2, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5, 6]]
    ]

    @datasets.each do |data|
      assert_raises ArgumentError do
        g.data(*data)
      end
    end
  end

  def test_empty_set_of_axis_values
    g = Gruff::Scatter.new
    g.title = 'Missing Axis Values'

    @datasets = [
      [:data1, [1, 2, 3, 4, 5]]
    ]

    @datasets.each do |data|
      assert_raises ArgumentError do
        g.data(*data)
      end
    end
  end

  def test_no_title
    g = Gruff::Scatter.new(400)
    g.data(:data1, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5])
    g.write('test/output/scatter_no_title.png')
    assert_same_image('test/expected/scatter_no_title.png', 'test/output/scatter_no_title.png')
  end

  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/scatter_no_line_markers.png')
    assert_same_image('test/expected/scatter_no_line_markers.png', 'test/output/scatter_no_line_markers.png')
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = 'No Legend'
    g.hide_legend = true
    g.write('test/output/scatter_no_legend.png')
    assert_same_image('test/expected/scatter_no_legend.png', 'test/output/scatter_no_legend.png')
  end

  def test_nothing_but_the_graph
    g = setup_basic_graph(400)
    g.title = 'THIS TITLE SHOULD NOT DISPLAY!!!'
    g.hide_line_markers = true
    g.hide_legend = true
    g.hide_title = true
    g.write('test/output/scatter_nothing_but_the_graph.png')
    assert_same_image('test/expected/scatter_nothing_but_the_graph.png', 'test/output/scatter_nothing_but_the_graph.png')
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = 'Wide Graph'
    g.write('test/output/scatter_wide_graph.png')
    assert_same_image('test/expected/scatter_wide_graph.png', 'test/output/scatter_wide_graph.png')

    g = setup_basic_graph('400x200')
    g.title = 'Wide Graph Small'
    g.write('test/output/scatter_wide_graph_small.png')
    assert_same_image('test/expected/scatter_wide_graph_small.png', 'test/output/scatter_wide_graph_small.png')
  end

  def test_negative
    g = setup_pos_neg(800)
    g.write('test/output/scatter_pos_neg.png')
    assert_same_image('test/expected/scatter_pos_neg.png', 'test/output/scatter_pos_neg.png')

    g = setup_pos_neg(400)
    g.title = 'Pos/Neg Line Test Small'
    g.write('test/output/scatter_pos_neg_400.png')
    assert_same_image('test/expected/scatter_pos_neg_400.png', 'test/output/scatter_pos_neg_400.png')
  end

  def test_all_negative
    g = setup_all_neg(800)
    g.write('test/output/scatter_all_neg.png')
    assert_same_image('test/expected/scatter_all_neg.png', 'test/output/scatter_all_neg.png')

    g = setup_all_neg(400)
    g.title = 'All Neg Line Test Small'
    g.write('test/output/scatter_all_neg_400.png')
    assert_same_image('test/expected/scatter_all_neg_400.png', 'test/output/scatter_all_neg_400.png')
  end

  def test_no_hide_line_no_labels
    g = Gruff::Scatter.new
    g.title = 'No Hide Line No Labels'
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g.hide_line_markers = false
    g.write('test/output/scatter_no_hide.png')
    assert_same_image('test/expected/scatter_no_hide.png', 'test/output/scatter_no_hide.png')
  end

  def test_no_set_labels
    g = Gruff::Scatter.new
    g.title = 'Setting Labels Test'
    g.labels = {
      0 => 'This',
      1 => 'should',
      2 => 'not',
      3 => 'show',
      4 => 'up'
    }
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g.write('test/output/scatter_no_labels.png')
    assert_same_image('test/expected/scatter_no_labels.png', 'test/output/scatter_no_labels.png')
  end

  def test_xy_data
    g = Gruff::Scatter.new
    g.title = 'Setting Labels Test'
    g.dataxy('Apples', [1, 3, 4, 5, 6, 10], [1, 2, 3, 4, 4, 3])
    g.dataxy('Bapples', [1, 3, 4, 5, 7, 9], [1, 1, 2, 2, 3, 3])
    g.write('test/output/scatter_xy.png')
    assert_same_image('test/expected/scatter_xy.png', 'test/output/scatter_xy.png')
  end

  def test_show_vertical_markers
    g = Gruff::Scatter.new
    g.title = 'Show vertical markers'

    g.dataxy('Apples', [1, 3, 4, 5, 6, 10], [1, 2, 3, 4, 4, 3])
    g.dataxy('Bapples', [1, 3, 4, 5, 7, 9], [1, 1, 2, 2, 3, 3])

    g.show_vertical_markers = true
    g.marker_shadow_color = '#888888'

    g.write('test/output/scatter_show_vertical_markers.png')
    assert_same_image('test/expected/scatter_show_vertical_markers.png', 'test/output/scatter_show_vertical_markers.png')
  end

  def test_hide_line_numbers
    g = Gruff::Scatter.new
    g.title = 'Show vertical markers'

    g.dataxy('Apples', [1, 3, 4, 5, 6, 10], [1, 2, 3, 4, 4, 3])
    g.dataxy('Bapples', [1, 3, 4, 5, 7, 9], [1, 1, 2, 2, 3, 3])

    g.show_vertical_markers = true
    g.hide_line_numbers = true
    g.marker_shadow_color = '#888888'

    g.write('test/output/scatter_hide_line_numbers.png')
    assert_same_image('test/expected/scatter_hide_line_numbers.png', 'test/output/scatter_hide_line_numbers.png')
  end

  def test_data_duck_typing
    g = Gruff::Scatter.new

    obj = Object.new
    def obj.to_a
      [1, 2, 3, 4, 5]
    end
    g.dataxy('Apples', obj, obj)

    pass
  end

  def test_minimum_x
    g = Gruff::Scatter.new
    g.minimum_x_value = 3
    g.dataxy('foo', [1, 2, 3, 4, 5], [21, 22, 23, 24, 25])
    g.dataxy('bar', [6, 7, 8, 9, 10], [26, 27, 28, 29, 30])

    g = Gruff::Scatter.new
    g.dataxy('foo', [1, 2, 3, 4, 5], [21, 22, 23, 24, 25])
    g.dataxy('bar', [6, 7, 8, 9, 10], [26, 27, 28, 29, 30])
    g.minimum_x_value = 3

    pass
  end

  def test_maximum
    g = Gruff::Scatter.new
    g.maximum_x_value = 3
    g.dataxy('foo', [1, 2, 3, 4, 5], [21, 22, 23, 24, 25])
    g.dataxy('bar', [6, 7, 8, 9, 10], [26, 27, 28, 29, 30])

    g = Gruff::Scatter.new
    g.dataxy('foo', [1, 2, 3, 4, 5], [21, 22, 23, 24, 25])
    g.dataxy('bar', [6, 7, 8, 9, 10], [26, 27, 28, 29, 30])
    g.maximum_x_value = 3

    pass
  end

  def test_x_axis_increment
    g = Gruff::Scatter.new
    g.data(:apples, [1, 2, 3, 4], [4, 3, 2, 1])
    g.data('oranges', [5, 7, 8], [4, 1, 7])
    g.x_axis_increment = 2
    g.write('test/output/scatter_x_axis_increment.png')
    assert_same_image('test/expected/scatter_x_axis_increment.png', 'test/output/scatter_x_axis_increment.png')
  end

  def test_duck_typing
    g = Gruff::Scatter.new
    g.dataxy('foo', GruffCustomData.new([1, 2, 3, 4, 5]), GruffCustomData.new([21, 22, 23, 24, 25]), '#113285')
    g.dataxy('bar', GruffCustomData.new([6, 7, 8, 9, 10]), GruffCustomData.new([26, 27, 28, 29, 30]), '#86A697')

    g.write('test/output/scatter_duck_typing.png')
    assert_same_image('test/expected/scatter_duck_typing.png', 'test/output/scatter_duck_typing.png')
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::Scatter.new(size)
    g.title = 'Rad Graph'
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g
  end

  def setup_pos_neg(size = 800)
    g = Gruff::Scatter.new(size)
    g.title = 'Pos/Neg Scatter Graph Test'
    g.data(:apples, [-1, 0, 4, -4], [-5, -1, 3, 4])
    g.data(:peaches, [10, 8, 6, 3], [-1, 1, 3, 3])
    g
  end

  def setup_all_neg(size = 800)
    g = Gruff::Scatter.new(size)
    g.title = 'Neg Scatter Graph Test'
    g.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4])
    g.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3])
    g
  end
end

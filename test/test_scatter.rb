#!/usr/bin/ruby

require File.dirname(__FILE__) + '/gruff_test_case'

class TestGruffScatter < Minitest::Test

  def setup
    @datasets = [
        [:Chuck, [20, 10, 5, 12, 11, 6, 10, 7], [5, 10, 19, 6, 9, 1, 14, 8]],
        [:Brown, [5, 10, 20, 6, 9, 12, 14, 8], [20, 10, 5, 12, 11, 6, 10, 7]],
        [:Lucy, [19, 9, 6, 11, 12, 7, 15, 8], [6, 11, 18, 8, 12, 8, 10, 6]]
    ]
  end

  # Done
  def test_scatter_graph
    g = setup_basic_graph
    g.title = 'Basic Scatter Plot Test'
    g.write('test/output/scatter_basic.png')
  end

  #~ # Done
  def test_many_datapoints
    g = Gruff::Scatter.new
    g.title = 'Many Datapoint Graph Test'
    y_values = (0..50).map { rand(100) }
    x_values = (0..50).map { rand(100) }
    g.data('many points', x_values, y_values)

    # Default theme
    g.write('test/output/scatter_many.png')
  end

  def test_custom_label_format
    g = Gruff::Scatter.new('1000x500')
    g.top_margin = 0
    g.hide_legend = true
    g.hide_title = true
    g.marker_font_size = 10
    g.theme = {
      :colors => ['#12a702', '#aedaa9'],
      :marker_color => '#dddddd',
      :font_color => 'black',
      :background_colors => 'white'
    }

    # Points style
    g.circle_radius = 1
    g.stroke_width = 0.01

    # Axis labels
    g.x_label_margin = 40
    g.bottom_margin = 60
    g.disable_significant_rounding_x_axis = true
    g.use_vertical_x_labels = true
    g.enable_vertical_line_markers = true
    g.marker_x_count = 50 # One label every 2 days
    g.x_axis_label_format = lambda do |value|
      DateTime.strptime(value.to_i.to_s,'%s').strftime('%d.%m.%Y')
    end
    g.y_axis_increment = 1

    # Fake data (100 days, random times of day between 5 and 16)
    r = Random.new(269155)
    y_values = (0..100).map { 5 + r.rand(12) }
    x_values = (0..100).map { |i| Date.today.strftime('%s').to_i + i*3600*24 }
    g.data('many points', x_values, y_values)
    g.write('test/output/scatter_custom_label_format.png')
  end

  # Done
  def test_no_data
    g = Gruff::Scatter.new(400)
    g.title = 'No Data'
    # Default theme
    g.write('test/output/scatter_no_data.png')

    g = Gruff::Scatter.new(400)
    g.title = 'No Data Title'
    g.no_data_message = 'There is no data'
    g.write('test/output/scatter_no_data_msg.png')
  end

  # Done
  def test_all_zeros
    g = Gruff::Scatter.new(400)
    g.title = 'All Zeros'

    g.data(:gus, [0, 0, 0, 0], [0, 0, 0, 0])

    # Default theme
    g.write('test/output/scatter_no_data_other.png')
  end

  # Done
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

  # Done
  def test_unequal_number_of_x_and_y_values
    g = Gruff::Scatter.new
    g.title = 'Unequal number of X and Y values'

    @datasets = [
        [:data1, [1, 2, 3], [1, 2]],
        [:data2, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5, 6]],
    ]

    @datasets.each do |data|
      assert_raises ArgumentError do
        g.data(*data)
      end
    end
  end

  # Done
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

  # Done
  def test_no_title
    g = Gruff::Scatter.new(400)
    g.data(:data1, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5])
    g.write('test/output/scatter_no_title.png')
  end

  # Done
  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/scatter_no_line_markers.png')
  end

  # Done
  def test_no_legend
    g = setup_basic_graph(400)
    g.title = 'No Legend'
    g.hide_legend = true
    g.write('test/output/scatter_no_legend.png')
  end

  # Done
  def test_nothing_but_the_graph
    g = setup_basic_graph(400)
    g.title = 'THIS TITLE SHOULD NOT DISPLAY!!!'
    g.hide_line_markers = true
    g.hide_legend = true
    g.hide_title = true
    g.write('test/output/scatter_nothing_but_the_graph.png')
  end

  # TODO Implement baselines on x and y axis
  #~ def test_baseline_larger_than_data
  #~ g = setup_basic_graph(400)
  #~ g.title = "Baseline Larger Than Data"
  #~ g.baseline_value = 150
  #~ g.write("test/output/scatter_large_baseline.png")
  #~ end

  # Done
  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = 'Wide Graph'
    g.write('test/output/scatter_wide_graph.png')

    g = setup_basic_graph('400x200')
    g.title = 'Wide Graph Small'
    g.write('test/output/scatter_wide_graph_small.png')
  end

  # Done
  def test_negative
    g = setup_pos_neg(800)
    g.write('test/output/scatter_pos_neg.png')

    g = setup_pos_neg(400)
    g.title = 'Pos/Neg Line Test Small'
    g.write('test/output/scatter_pos_neg_400.png')
  end

  # Done
  def test_all_negative
    g = setup_all_neg(800)
    g.write('test/output/scatter_all_neg.png')

    g = setup_all_neg(400)
    g.title = 'All Neg Line Test Small'
    g.write('test/output/scatter_all_neg_400.png')
  end

  # Done
  def test_no_hide_line_no_labels
    g = Gruff::Scatter.new
    g.title = 'No Hide Line No Labels'
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g.hide_line_markers = false
    g.write('test/output/scatter_no_hide.png')
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
  end

  protected

  def setup_basic_graph(size=800)
    g = Gruff::Scatter.new(size)
    g.title = 'Rad Graph'
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g
  end

  def setup_pos_neg(size=800)
    g = Gruff::Scatter.new(size)
    g.title = 'Pos/Neg Scatter Graph Test'
    g.data(:apples, [-1, 0, 4, -4], [-5, -1, 3, 4])
    g.data(:peaches, [10, 8, 6, 3], [-1, 1, 3, 3])
    g
  end

  def setup_all_neg(size=800)
    g = Gruff::Scatter.new(size)
    g.title = 'Neg Scatter Graph Test'
    g.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4])
    g.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3])
    g
  end

end # end GruffTestCase

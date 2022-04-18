# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffPie < GruffTestCase
  def setup
    @datasets = [
      [:Darren, [25]],
      [:Chris, [80]],
      [:Egbert, [22]],
      [:Adam, [95]],
      [:Bill, [90]],
      ['Frank', [5]],
      ['Zero', [0]]
    ]
  end

  def test_pie_graph
    g = Gruff::Pie.new
    g.title = 'Visual Pie Graph Test'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/pie_keynote.png')
    assert_same_image('test/expected/pie_keynote.png', 'test/output/pie_keynote.png')
  end

  def test_pie_graph_greyscale
    g = Gruff::Pie.new
    g.title = 'Greyscale Pie Graph Test'
    g.theme = Gruff::Themes::GREYSCALE
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/pie_grey.png')
    assert_same_image('test/expected/pie_grey.png', 'test/output/pie_grey.png')
  end

  def test_pie_graph_pastel
    g = Gruff::Pie.new
    g.theme = Gruff::Themes::PASTEL
    g.title = 'Pastel Pie Graph Test'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/pie_pastel.png')
    assert_same_image('test/expected/pie_pastel.png', 'test/output/pie_pastel.png')
  end

  def test_pie_graph_small
    g = Gruff::Pie.new(400)
    g.title = 'Visual Pie Graph Test Small'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/pie_keynote_small.png')
    assert_same_image('test/expected/pie_keynote_small.png', 'test/output/pie_keynote_small.png')
  end

  def test_pie_graph_nearly_equal
    g = Gruff::Pie.new
    g.title = 'Pie Graph Nearly Equal'

    g.data(:Blake, [41])
    g.data(:Aaron, [42])

    g.write('test/output/pie_nearly_equal.png')
    assert_same_image('test/expected/pie_nearly_equal.png', 'test/output/pie_nearly_equal.png')
  end

  def test_pie_graph_equal
    g = Gruff::Pie.new
    g.title = 'Pie Graph Equal'

    g.data(:Bert, [41])
    g.data(:Adam, [41])

    g.write('test/output/pie_equal.png')
    assert_same_image('test/expected/pie_equal.png', 'test/output/pie_equal.png')
  end

  def test_pie_graph_zero
    g = Gruff::Pie.new
    g.title = 'Pie Graph One Zero'

    g.data(:Bert, [0])
    g.data(:Adam, [1])

    g.write('test/output/pie_zero.png')
    assert_same_image('test/expected/pie_zero.png', 'test/output/pie_zero.png')
  end

  def test_pie_graph_one_val
    g = Gruff::Pie.new
    g.title = 'Pie Graph One Val'

    g.data(:Bert, 53)
    g.data(:Adam, 29)

    g.write('test/output/pie_one_val.png')
    assert_same_image('test/expected/pie_one_val.png', 'test/output/pie_one_val.png')
  end

  def test_no_data
    g = Gruff::Pie.new
    g.title = 'No Data'
    # Default theme
    g.write('test/output/pie_no_data.png')
    assert_same_image('test/expected/pie_no_data.png', 'test/output/pie_no_data.png')

    g = Gruff::Pie.new
    g.title = 'No Data Title'
    g.no_data_message = 'There is no data'
    g.write('test/output/pie_no_data_msg.png')
    assert_same_image('test/expected/pie_no_data_msg.png', 'test/output/pie_no_data_msg.png')

    g = Gruff::Pie.new
    g.data 'A', []
    g.data 'B', []
    g.write('test/output/pie_no_data_with_empty.png')
    assert_same_image('test/expected/pie_no_data_with_empty.png', 'test/output/pie_no_data_with_empty.png')
  end

  def test_wide
    g = setup_basic_graph('800x400')
    g.title = 'Wide Pie'
    g.write('test/output/pie_wide.png')
    assert_same_image('test/expected/pie_wide.png', 'test/output/pie_wide.png')
  end

  def test_label_size
    g = setup_basic_graph
    g.title = 'Pie With Small Legend'
    g.legend_font_size = 10
    g.write('test/output/pie_legend.png')
    assert_same_image('test/expected/pie_legend.png', 'test/output/pie_legend.png')

    g = setup_basic_graph(400)
    g.title = 'Small Pie With Small Legend'
    g.legend_font_size = 10
    g.write('test/output/pie_legend_small.png')
    assert_same_image('test/expected/pie_legend_small.png', 'test/output/pie_legend_small.png')
  end

  def test_tiny_simple_pie
    r = Random.new(297_427)
    @datasets = (1..5).map { ['Auto', [r.rand(100)]] }

    g = setup_basic_graph 200
    g.hide_legend = true
    g.hide_title = true
    g.hide_line_numbers = true

    g.marker_font_size = 40.0
    g.minimum_value = 0.0

    write_test_file(g, 'pie_simple.png')
    assert_same_image('test/expected/pie_simple.png', 'test/output/pie_simple.png')
  end

  def test_pie_with_adjusted_text_offset_percentage
    g = setup_basic_graph
    g.title = 'Adjusted Text Offset Percentage'
    g.text_offset_percentage = 0.03
    g.write('test/output/pie_adjusted_text_offset_percentage.png')
    assert_same_image('test/expected/pie_adjusted_text_offset_percentage.png', 'test/output/pie_adjusted_text_offset_percentage.png')
  end

  def test_label_format
    g = setup_basic_graph
    g.title = 'Label format'
    g.label_formatting = lambda do |value, percentage|
      "#{value} (#{percentage}%)"
    end

    g.write('test/output/pie_label_format.png')
    assert_same_image('test/expected/pie_label_format.png', 'test/output/pie_label_format.png')
  end

  def test_zero_degree
    g = setup_basic_graph
    g.title = 'zero_degree'
    g.zero_degree = 90
  end

  def test_start_degree
    g = setup_basic_graph
    g.title = 'start_degree'
    g.start_degree = 90

    g.write('test/output/pie_start_degree.png')
    assert_same_image('test/expected/pie_start_degree.png', 'test/output/pie_start_degree.png')
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::Pie.new(size)
    g.title = 'My Graph Title'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g
  end
end

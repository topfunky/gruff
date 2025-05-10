# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffStackedBar < GruffTestCase
  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]]
    ]
  end

  def test_bar_graph
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [2, 29, 35, 38]]
    ]
    g = setup_basic_graph
    g.title = 'Visual Stacked Bar Graph Test'
    g.show_labels_for_bar_values = true
    g.write('test/output/stacked_bar_keynote.png')

    assert_same_image('test/expected/stacked_bar_keynote.png', 'test/output/stacked_bar_keynote.png')
  end

  def test_bar_graph_small
    g = setup_basic_graph(400)
    g.title = 'Visual Stacked Bar Graph Test'
    g.write('test/output/stacked_bar_keynote_small.png')

    assert_same_image('test/expected/stacked_bar_keynote_small.png', 'test/output/stacked_bar_keynote_small.png')
  end

  def test_bar_graph_segment_spacing
    g = setup_basic_graph
    g.title = 'Visual Stacked Bar Graph Test'
    g.segment_spacing = 0
    g.write('test/output/stacked_bar_keynote_no_space.png')

    assert_same_image('test/expected/stacked_bar_keynote_no_space.png', 'test/output/stacked_bar_keynote_no_space.png')
  end

  def test_no_labels
    g = setup_basic_graph(400)
    g.title = 'No Labels'
    g.hide_labels = true
    g.write('test/output/stacked_bar_no_labels.png')

    assert_same_image('test/expected/stacked_bar_no_labels.png', 'test/output/stacked_bar_no_labels.png')
  end

  def test_no_line_markers_or_labels
    g = setup_basic_graph(400)
    g.title = 'No Line Markers or Labels'
    g.hide_labels = true
    g.hide_line_markers = true
    g.write('test/output/stacked_bar_no_line_markers_or_labels.png')

    assert_same_image('test/expected/stacked_bar_no_line_markers_or_labels.png', 'test/output/stacked_bar_no_line_markers_or_labels.png')
  end

  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/stacked_bar_no_line_markers.png')

    assert_same_image('test/expected/stacked_bar_no_line_markers.png', 'test/output/stacked_bar_no_line_markers.png')
  end

  def test_label_format
    g = setup_basic_graph(400)
    g.title = 'Label format'
    g.show_labels_for_bar_values = true
    g.label_formatting = lambda do |value|
      "V-#{value.to_i}"
    end
    g.y_axis_label_format = lambda do |value|
      "Y-#{value.to_i}"
    end

    g.write('test/output/stacked_bar_label_format.png')

    assert_same_image('test/expected/stacked_bar_label_format.png', 'test/output/stacked_bar_label_format.png')
  end

  def test_axis_label_with_hide_line_markers
    g = setup_basic_graph
    g.title = 'Axis Label with Hide Line Markers'
    g.hide_line_markers = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/stacked_bar_axis_label_with_hide_line_markers.png')

    assert_same_image('test/expected/stacked_bar_axis_label_with_hide_line_markers.png',
                      'test/output/stacked_bar_axis_label_with_hide_line_markers.png')
  end

  def test_axis_label_with_legend_at_bottom
    g = setup_basic_graph
    g.title = 'Axis Label with Legend at Bottom'
    g.legend_at_bottom = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/stacked_bar_axis_label_with_legend_at_bottom.png')

    assert_same_image('test/expected/stacked_bar_axis_label_with_legend_at_bottom.png',
                      'test/output/stacked_bar_axis_label_with_legend_at_bottom.png')
  end

  def test_empty_data
    g = Gruff::StackedBar.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [nil, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.write('test/output/stacked_bar_empty_data.png')

    assert_same_image('test/expected/stacked_bar_empty_data.png', 'test/output/stacked_bar_empty_data.png')
  end

  def test_duck_typing
    g = Gruff::StackedBar.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/stacked_bar_duck_typing.png')

    assert_same_image('test/expected/stacked_bar_duck_typing.png', 'test/output/stacked_bar_duck_typing.png')
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::StackedBar.new(size)
    g.title = 'My Stacked Bar Graph'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g
  end
end

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

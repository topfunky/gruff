# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffSideStackedBar < GruffTestCase
  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]]
      #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
      #[:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
      #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
    ]
    @labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @long_labels = {
      0 => 'September',
      1 => 'Oct',
      2 => 'Nov',
      3 => 'Dec'
    }
  end

  def test_bar_graph
    g = setup_basic_graph
    g.title = 'Visual Stacked Bar Graph Test'
    g.write('test/output/side_stacked_bar_keynote.png')
    assert_same_image('test/expected/side_stacked_bar_keynote.png', 'test/output/side_stacked_bar_keynote.png')
  end

  def test_bar_graph_small
    g = setup_basic_graph(400)
    g.title = 'Visual Stacked Bar Graph Test'
    g.write('test/output/side_stacked_bar_keynote_small.png')
    assert_same_image('test/expected/side_stacked_bar_keynote_small.png', 'test/output/side_stacked_bar_keynote_small.png')
  end

  def test_wide
    @labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24'
    }
    g = setup_basic_graph('800x400')
    g.title = 'Wide SSBar'
    g.write('test/output/side_stacked_bar_wide.png')
    assert_same_image('test/expected/side_stacked_bar_wide.png', 'test/output/side_stacked_bar_wide.png')
  end

  def test_should_space_long_left_labels_appropriately
    @labels = @long_labels
    g = setup_basic_graph
    g.title = 'Stacked Bar Long Label'
    g.write('test/output/side_stacked_bar_long_label.png')
    assert_same_image('test/expected/side_stacked_bar_long_label.png', 'test/output/side_stacked_bar_long_label.png')
  end

  def test_bar_labels
    @labels = @long_labels
    g = setup_basic_graph
    g.title = 'Stacked Bar Long Label'
    g.show_labels_for_bar_values = true
    g.write('test/output/side_stacked_bar_labels.png')
    assert_same_image('test/expected/side_stacked_bar_labels.png', 'test/output/side_stacked_bar_labels.png')
  end

  def test_no_labels
    @labels = @long_labels
    g = setup_basic_graph(400)
    g.title = 'No Labels'
    g.hide_labels = true
    g.write('test/output/side_stacked_bar_no_labels.png')
    assert_same_image('test/expected/side_stacked_bar_no_labels.png', 'test/output/side_stacked_bar_no_labels.png')
  end

  def test_no_line_markers_or_labels
    @labels = @long_labels
    g = setup_basic_graph(400)
    g.title = 'No Line Markers or Labels'
    g.hide_labels = true
    g.hide_line_markers = true
    g.write('test/output/side_stacked_bar_no_line_markers_or_labels.png')
    assert_same_image('test/expected/side_stacked_bar_no_line_markers_or_labels.png', 'test/output/side_stacked_bar_no_line_markers_or_labels.png')
  end

  def test_no_line_markers
    @labels = @long_labels
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/side_stacked_bar_no_line_markers.png')
    assert_same_image('test/expected/side_stacked_bar_no_line_markers.png', 'test/output/side_stacked_bar_no_line_markers.png')
  end

  def test_draw_twice
    g = setup_basic_graph
    g.show_labels_for_bar_values = true
    g.draw
    g.draw

    pass
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::SideStackedBar.new(size)
    g.title = 'My Graph Title'
    g.labels = @labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g
  end
end

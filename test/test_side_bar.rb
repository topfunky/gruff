# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffSideBar < GruffTestCase
  def test_bar_graph
    g = setup_basic_graph(Gruff::SideBar, 800)
    write_test_file(g, 'side_bar.png')

    assert_same_image('test/expected/side_bar.png', 'test/output/side_bar.png')
  end

  def test_bar_spacing
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 0
    g.title = '100% spacing between bars'
    g.write('test/output/side_bar_spacing_full.png')

    assert_same_image('test/expected/side_bar_spacing_full.png', 'test/output/side_bar_spacing_full.png')

    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 0.5
    g.title = '50% spacing between bars'
    g.write('test/output/side_bar_spacing_half.png')

    assert_same_image('test/expected/side_bar_spacing_half.png', 'test/output/side_bar_spacing_half.png')

    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 1
    g.title = '0% spacing between bars'
    g.write('test/output/side_bar_spacing_none.png')

    assert_same_image('test/expected/side_bar_spacing_none.png', 'test/output/side_bar_spacing_none.png')
  end

  def test_group_spacing
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.group_spacing = 30
    g.title = 'Group spacing'
    g.write('test/output/side_bar_group_spacing.png')

    assert_same_image('test/expected/side_bar_group_spacing.png', 'test/output/side_bar_group_spacing.png')
  end

  def test_x_axis_range
    g = Gruff::SideBar.new('400x300')
    g.title = 'Should run from 8 to 32'
    g.hide_line_numbers = false
    g.theme_37signals
    g.data('Grapes', [8])
    g.data('Apples', [24])
    g.data('Oranges', [32])
    g.data('Watermelon', [8])
    g.data('Peaches', [12])
    g.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }
    g.write('test/output/side_bar_data_range.png')

    assert_same_image('test/expected/side_bar_data_range.png', 'test/output/side_bar_data_range.png')
  end

  def test_bar_labels
    g = Gruff::SideBar.new('400x300')
    g.title = 'Should show labels for each bar'
    g.data('Grapes', [8])
    g.data('Apples', [24])
    g.data('Oranges', [32])
    g.data('Watermelon', [8])
    g.data('Peaches', [12])
    g.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }
    g.show_labels_for_bar_values = true
    g.write('test/output/side_bar_labels.png')

    assert_same_image('test/expected/side_bar_labels.png', 'test/output/side_bar_labels.png')
  end

  def test_label_format
    g = Gruff::SideBar.new('400x300')
    g.title = 'Label format'
    g.data('Grapes', [8])
    g.data('Apples', [24])
    g.data('Oranges', [32])
    g.data('Watermelon', [8])
    g.data('Peaches', [12])
    g.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }
    g.show_labels_for_bar_values = true
    g.label_formatting = lambda do |value|
      "V-#{value.to_i}"
    end
    g.x_axis_label_format = lambda do |value|
      "X-#{value.to_i}"
    end

    g.write('test/output/side_bar_label_format.png')

    assert_same_image('test/expected/side_bar_label_format.png', 'test/output/side_bar_label_format.png')
  end

  def test_no_labels
    g = setup_basic_graph(Gruff::SideBar, 400)
    g.title = 'No Labels'
    g.hide_labels = true
    g.write('test/output/side_bar_no_labels.png')

    assert_same_image('test/expected/side_bar_no_labels.png', 'test/output/side_bar_no_labels.png')
  end

  def test_no_line_markers_or_labels
    g = setup_basic_graph(Gruff::SideBar, 400)
    g.title = 'No Line Markers or Labels'
    g.hide_labels = true
    g.hide_line_markers = true
    g.write('test/output/side_bar_no_line_markers_or_labels.png')

    assert_same_image('test/expected/side_bar_no_line_markers_or_labels.png', 'test/output/side_bar_no_line_markers_or_labels.png')
  end

  def test_no_line_markers
    g = setup_basic_graph(Gruff::SideBar, 400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/side_bar_no_line_markers.png')

    assert_same_image('test/expected/side_bar_no_line_markers.png', 'test/output/side_bar_no_line_markers.png')
  end

  def test_draw_twice
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.show_labels_for_bar_values = true
    g.draw
    g.draw

    pass
  end

  def test_use_data_label
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.use_data_label = true

    pass
  end

  def test_negative
    g = Gruff::SideBar.new(800)
    g.title = 'Pos/Neg SideBar Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])
    g.show_labels_for_bar_values = true
    g.write('test/output/side_bar_pos_neg.png')

    assert_same_image('test/expected/side_bar_pos_neg.png', 'test/output/side_bar_pos_neg.png')
  end

  def test_all_negative
    g = Gruff::SideBar.new(800)
    g.title = 'All Neg SideBar Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:apples, [-1, -5, -20, -4])
    g.data(:peaches, [-10, -8, -6, -3])
    g.show_labels_for_bar_values = true
    g.write('test/output/side_bar_all_neg.png')

    assert_same_image('test/expected/side_bar_all_neg.png', 'test/output/side_bar_all_neg.png')
  end

  def test_set_label_max_size_and_label_truncation_style
    g = Gruff::SideBar.new(800)
    g.title = 'Label truncation style'
    g.labels = {
      0 => 'January was a cold one',
      1 => 'February is little better',
      2 => 'March will bring me hares',
      3 => 'April and I\'m a fool'
    }
    g.label_max_size = 6
    g.label_truncation_style = :trailing_dots
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])
    g.write('test/output/side_bar_set_trailing_dots_trunc.png')

    assert_same_image('test/expected/side_bar_set_trailing_dots_trunc.png', 'test/output/side_bar_set_trailing_dots_trunc.png')
  end

  def test_axis_label_with_hide_line_markers
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.title = 'Axis Label with Hide Line Markers'
    g.hide_line_markers = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/side_bar_axis_label_with_hide_line_markers.png')

    assert_same_image('test/expected/side_bar_axis_label_with_hide_line_markers.png', 'test/output/side_bar_axis_label_with_hide_line_markers.png')
  end

  def test_axis_label_with_legend_at_bottom
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.title = 'Axis Label with Legend at Bottom'
    g.legend_at_bottom = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/side_bar_axis_label_with_legend_at_bottom.png')

    assert_same_image('test/expected/side_bar_axis_label_with_legend_at_bottom.png', 'test/output/side_bar_axis_label_with_legend_at_bottom.png')
  end

  def test_empty_data
    g = Gruff::SideBar.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.write('test/output/side_bar_empty_data.png')

    assert_same_image('test/expected/side_bar_empty_data.png', 'test/output/side_bar_empty_data.png')
  end

  def test_duck_typing
    g = Gruff::SideBar.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/side_bar_duck_typing.png')

    assert_same_image('test/expected/side_bar_duck_typing.png', 'test/output/side_bar_duck_typing.png')
  end
end

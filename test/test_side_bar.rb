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

  def test_draw_twice
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.show_labels_for_bar_values = true
    g.draw
    g.draw

    pass
  end
end

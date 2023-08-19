# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffDot < GruffTestCase
  # TODO: Delete old output files once when starting tests

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]]
    ]
  end

  def test_dot_graph
    g = setup_basic_graph
    g.title = 'Dot Graph Test'
    g.write('test/output/dot.png')

    assert_same_image('test/expected/dot.png', 'test/output/dot.png')
  end

  def test_dot_graph_set_colors
    g = Gruff::Dot.new
    g.title = 'Dot Graph With Manual Colors'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:Art, [0, 5, 8, 15], '#990000')
    g.data(:Philosophy, [10, 3, 2, 8], '#009900')
    g.data(:Science, [2, 15, 8, 11], '#990099')

    g.minimum_value = 0

    g.write('test/output/dot_manual_colors.png')

    assert_same_image('test/expected/dot_manual_colors.png', 'test/output/dot_manual_colors.png')
  end

  def test_dot_graph_small
    g = setup_basic_graph(400)
    g.title = 'Visual Multi-Line Dot Graph Test'
    g.write('test/output/dot_small.png')

    assert_same_image('test/expected/dot_small.png', 'test/output/dot_small.png')
  end

  def test_no_labels
    g = setup_basic_graph(400)
    g.title = 'No Labels'
    g.hide_labels = true
    g.write('test/output/dot_no_labels.png')

    assert_same_image('test/expected/dot_no_labels.png', 'test/output/dot_no_labels.png')
  end

  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/dot_no_line_markers.png')

    assert_same_image('test/expected/dot_no_line_markers.png', 'test/output/dot_no_line_markers.png')
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = 'No Legend'
    g.hide_legend = true
    g.write('test/output/dot_no_legend.png')

    assert_same_image('test/expected/dot_no_legend.png', 'test/output/dot_no_legend.png')
  end

  def test_no_title
    g = setup_basic_graph(400)
    g.title = 'No Title'
    g.hide_title = true
    g.write('test/output/dot_no_title.png')

    assert_same_image('test/expected/dot_no_title.png', 'test/output/dot_no_title.png')
  end

  def test_no_title_or_legend
    g = setup_basic_graph(400)
    g.title = 'No Title or Legend'
    g.hide_legend = true
    g.hide_title = true
    g.write('test/output/dot_no_title_or_legend.png')

    assert_same_image('test/expected/dot_no_title_or_legend.png', 'test/output/dot_no_title_or_legend.png')
  end

  def test_set_marker_count
    g = setup_basic_graph(400)
    g.title = 'Set marker'
    g.marker_count = 10
    g.write('test/output/dot_set_marker.png')

    assert_same_image('test/expected/dot_set_marker.png', 'test/output/dot_set_marker.png')
  end

  def test_set_legend_box_size
    g = setup_basic_graph(400)
    g.title = 'Set Small Legend Box Size'
    g.legend_box_size = 10.0
    g.write('test/output/dot_set_legend_box_size_sm.png')

    assert_same_image('test/expected/dot_set_legend_box_size_sm.png', 'test/output/dot_set_legend_box_size_sm.png')

    g = setup_basic_graph(400)
    g.title = 'Set Large Legend Box Size'
    g.legend_box_size = 50.0
    g.write('test/output/dot_set_legend_box_size_lg.png')

    assert_same_image('test/expected/dot_set_legend_box_size_lg.png', 'test/output/dot_set_legend_box_size_lg.png')
  end

  def test_x_y_labels
    g = setup_basic_graph(400)
    g.title = 'X Y Labels'
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = 'Students'
    g.write('test/output/dot_x_y_labels.png')

    assert_same_image('test/expected/dot_x_y_labels.png', 'test/output/dot_x_y_labels.png')
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = 'Wide Graph'
    g.write('test/output/dot_wide_graph.png')

    assert_same_image('test/expected/dot_wide_graph.png', 'test/output/dot_wide_graph.png')

    g = setup_basic_graph('400x200')
    g.title = 'Wide Graph Small'
    g.write('test/output/dot_wide_graph_small.png')

    assert_same_image('test/expected/dot_wide_graph_small.png', 'test/output/dot_wide_graph_small.png')
  end

  def test_tall_graph
    g = setup_basic_graph('400x600')
    g.title = 'Tall Graph'
    g.write('test/output/dot_tall_graph.png')

    assert_same_image('test/expected/dot_tall_graph.png', 'test/output/dot_tall_graph.png')

    g = setup_basic_graph('200x400')
    g.title = 'Tall Graph Small'
    g.write('test/output/dot_tall_graph_small.png')

    assert_same_image('test/expected/dot_tall_graph_small.png', 'test/output/dot_tall_graph_small.png')
  end

  def test_one_value
    g = Gruff::Dot.new
    g.title = 'One Value Graph Test'
    g.labels = {
      0 => '1',
      1 => '2'
    }
    g.data('one', [1, 1])

    g.write('test/output/dot_one_value.png')

    assert_same_image('test/expected/dot_one_value.png', 'test/output/dot_one_value.png')
  end

  def test_negative
    g = Gruff::Dot.new
    g.title = 'Pos/Neg Dot Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])

    g.write('test/output/dot_pos_neg.png')

    assert_same_image('test/expected/dot_pos_neg.png', 'test/output/dot_pos_neg.png')
  end

  def test_nearly_zero
    g = Gruff::Dot.new
    g.title = 'Nearly Zero Graph'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:apples, [1, 2, 3, 4])
    g.data(:peaches, [4, 3, 2, 1])
    g.minimum_value = 0
    g.maximum_value = 10
    g.write('test/output/dot_nearly_zero_max_10.png')

    assert_same_image('test/expected/dot_nearly_zero_max_10.png', 'test/output/dot_nearly_zero_max_10.png')
  end

  def test_y_axis_increment
    generate_with_y_axis_increment 2.0
    generate_with_y_axis_increment 1
    generate_with_y_axis_increment 5
    generate_with_y_axis_increment 20
  end

  def generate_with_y_axis_increment(increment)
    g = Gruff::Dot.new
    g.title = "Y Axis Set to #{increment}"
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.y_axis_increment = increment
    g.data(:apples, [1, 0.2, 0.5, 0.7])
    g.data(:peaches, [2.5, 2.3, 2, 6.1])
    g.write("test/output/dot_y_increment_#{increment}.png")

    assert_same_image("test/expected/dot_y_increment_#{increment}.png", "test/output/dot_y_increment_#{increment}.png")
  end

  def test_custom_theme
    g = Gruff::Dot.new
    g.title = 'Custom Theme'
    g.font = File.join(fixtures_dir, 'ComicNeue-Regular.ttf')
    g.title_font_size = 60
    g.legend_font_size = 32
    g.marker_font_size = 32
    g.theme = {
      colors: %w[#efd250 #666699 #e5573f #9595e2],
      marker_color: 'white',
      font_color: 'blue',
      background_image: File.join(fixtures_dir, 'pc306715.jpg')
    }
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:vancouver, [1, 2, 3, 4])
    g.data(:seattle, [2, 4, 6, 8])
    g.data(:portland, [3, 1, 7, 3])
    g.data(:victoria, [4, 3, 5, 7])
    g.minimum_value = 0
    g.write('test/output/dot_themed.png')

    assert_same_image('test/expected/dot_themed.png', 'test/output/dot_themed.png')
  end

  def test_july_enhancements
    g = Gruff::Dot.new(600)
    g.hide_legend = true
    g.title = 'Full speed ahead'
    g.labels = (0..10).reduce({}) { |memo, i| memo.merge({ i => (i * 10).to_s }) }
    g.data(:apples, [1.7, 0.8, 0.1, 1.9, 1.4, 0.6, 1.1, 0.7, 1.4, 0.2])
    g.y_axis_increment = 1.0
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = 'Students'
    write_test_file(g, 'enhancements_dot.png')

    assert_same_image('test/expected/enhancements_dot.png', 'test/output/enhancements_dot.png')
  end

  def test_set_label_max_size_and_label_truncation_style
    g = setup_basic_graph(400)
    g.labels = {
      0 => 'January was a cold one',
      1 => 'February is little better',
      2 => 'March will bring me hares',
      3 => 'April and I\'m a fool'
    }
    g.title = 'Label truncation style'
    g.label_max_size = 6
    g.label_truncation_style = :trailing_dots
    g.write('test/output/dot_set_trailing_dots_trunc.png')

    assert_same_image('test/expected/dot_set_trailing_dots_trunc.png', 'test/output/dot_set_trailing_dots_trunc.png')
  end

  def test_empty_data
    g = Gruff::Dot.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.write('test/output/dot_empty_data.png')

    assert_same_image('test/expected/dot_empty_data.png', 'test/output/dot_empty_data.png')
  end

  def test_marker_shadow_color
    g = Gruff::Dot.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'
    g.marker_shadow_color = '#444'

    g.write('test/output/dot_marker_shadow_color.png')

    assert_same_image('test/expected/dot_marker_shadow_color.png', 'test/output/dot_marker_shadow_color.png')
  end

  def test_duck_typing
    g = Gruff::Dot.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/dot_duck_typing.png')

    assert_same_image('test/expected/dot_duck_typing.png', 'test/output/dot_duck_typing.png')
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::Dot.new(size)
    g.title = 'My Dot Graph'
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

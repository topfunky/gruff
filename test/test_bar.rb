# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffBar < GruffTestCase
  # TODO: Delete old output files once when starting tests

  def setup
    super
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]]
    ]
  end

  def test_bar_graph
    g = setup_basic_graph
    g.title = 'Bar Chart'
    g.write('test/output/bar_keynote.png')

    assert_same_image('test/expected/bar_keynote.png', 'test/output/bar_keynote.png')

    g = setup_basic_graph
    g.title = 'Visual Multi-Line Bar Graph Test'
    g.theme = Gruff::Themes::RAILS_KEYNOTE
    g.write('test/output/bar_rails_keynote.png')

    assert_same_image('test/expected/bar_rails_keynote.png', 'test/output/bar_rails_keynote.png')

    g = setup_basic_graph
    g.title = 'Visual Multi-Line Bar Graph Test'
    g.theme = Gruff::Themes::ODEO
    g.write('test/output/bar_odeo.png')

    assert_same_image('test/expected/bar_odeo.png', 'test/output/bar_odeo.png')
  end

  def test_title_margin
    g = setup_basic_graph
    g.title = 'Bar Graph with Title Margin = 100'
    g.title_margin = 100
    g.write('test/output/bar_title_margin.png')

    assert_same_image('test/expected/bar_title_margin.png', 'test/output/bar_title_margin.png')
  end

  def test_thousand_separators
    g = Gruff::Bar.new(600)
    g.title = 'Formatted numbers'
    g.marker_count = 8
    g.data('data', [4025, 1024, 50_257, 703_672, 1_580_456])
    g.write('test/output/bar_formatted_numbers.png')

    assert_same_image('test/expected/bar_formatted_numbers.png', 'test/output/bar_formatted_numbers.png')
  end

  def test_bar_graph_set_colors
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors'
    g.legend_margin = 50
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

    g.write('test/output/bar_manual_colors.png')

    assert_same_image('test/expected/bar_manual_colors.png', 'test/output/bar_manual_colors.png')
  end

  def test_bar_graph_small
    g = Gruff::Bar.new(400)
    g.title = 'Visual Multi-Line Bar Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write('test/output/bar_keynote_small.png')

    assert_same_image('test/expected/bar_keynote_small.png', 'test/output/bar_keynote_small.png')
  end

  # Somewhat worthless test. Should an error be thrown?
  # def test_nil_font
  #   g = setup_basic_graph 400
  #   g.title = "Nil Font"
  #   g.font = nil
  #   g.write "test/output/bar_nil_font.png"
  # end

  def test_no_labels
    g = setup_basic_graph(400)
    g.title = 'No Labels'
    g.hide_labels = true
    g.write('test/output/bar_no_labels.png')

    assert_same_image('test/expected/bar_no_labels.png', 'test/output/bar_no_labels.png')
  end

  def test_no_line_markers_or_labels
    g = setup_basic_graph(400)
    g.title = 'No Line Markers or Labels'
    g.hide_labels = true
    g.hide_line_markers = true
    g.write('test/output/bar_no_line_markers_or_labels.png')

    assert_same_image('test/expected/bar_no_line_markers_or_labels.png', 'test/output/bar_no_line_markers_or_labels.png')
  end

  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = 'No Line Markers'
    g.hide_line_markers = true
    g.write('test/output/bar_no_line_markers.png')

    assert_same_image('test/expected/bar_no_line_markers.png', 'test/output/bar_no_line_markers.png')
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = 'No Legend'
    g.hide_legend = true
    g.write('test/output/bar_no_legend.png')

    assert_same_image('test/expected/bar_no_legend.png', 'test/output/bar_no_legend.png')
  end

  def test_no_title
    g = setup_basic_graph(400)
    g.title = 'No Title'
    g.hide_title = true
    g.write('test/output/bar_no_title.png')

    assert_same_image('test/expected/bar_no_title.png', 'test/output/bar_no_title.png')
  end

  def test_no_title_or_legend
    g = setup_basic_graph(400)
    g.title = 'No Title or Legend'
    g.hide_legend = true
    g.hide_title = true
    g.write('test/output/bar_no_title_or_legend.png')

    assert_same_image('test/expected/bar_no_title_or_legend.png', 'test/output/bar_no_title_or_legend.png')
  end

  def test_set_marker_count
    g = setup_basic_graph(400)
    g.title = 'Set marker'
    g.marker_count = 10
    g.write('test/output/bar_set_marker.png')

    assert_same_image('test/expected/bar_set_marker.png', 'test/output/bar_set_marker.png')
  end

  def test_set_legend_box_size
    g = setup_basic_graph(400)
    g.title = 'Set Small Legend Box Size'
    g.legend_box_size = 10.0
    g.write('test/output/bar_set_legend_box_size_sm.png')

    assert_same_image('test/expected/bar_set_legend_box_size_sm.png', 'test/output/bar_set_legend_box_size_sm.png')

    g = setup_basic_graph(400)
    g.title = 'Set Large Legend Box Size'
    g.legend_box_size = 50.0
    g.write('test/output/bar_set_legend_box_size_lg.png')

    assert_same_image('test/expected/bar_set_legend_box_size_lg.png', 'test/output/bar_set_legend_box_size_lg.png')
  end

  def test_x_y_labels
    g = setup_basic_graph(400)
    g.title = 'X Y Labels'
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = 'Students'
    g.write('test/output/bar_x_y_labels.png')

    assert_same_image('test/expected/bar_x_y_labels.png', 'test/output/bar_x_y_labels.png')
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = 'Wide Graph'
    g.write('test/output/bar_wide_graph.png')

    assert_same_image('test/expected/bar_wide_graph.png', 'test/output/bar_wide_graph.png')

    g = setup_basic_graph('400x200')
    g.title = 'Wide Graph Small'
    g.write('test/output/bar_wide_graph_small.png')

    assert_same_image('test/expected/bar_wide_graph_small.png', 'test/output/bar_wide_graph_small.png')
  end

  def test_tall_graph
    g = setup_basic_graph('400x600')
    g.title = 'Tall Graph'
    g.write('test/output/bar_tall_graph.png')

    assert_same_image('test/expected/bar_tall_graph.png', 'test/output/bar_tall_graph.png')

    g = setup_basic_graph('200x400')
    g.title = 'Tall Graph Small'
    g.write('test/output/bar_tall_graph_small.png')

    assert_same_image('test/expected/bar_tall_graph_small.png', 'test/output/bar_tall_graph_small.png')
  end

  def test_one_value
    g = Gruff::Bar.new
    g.title = 'One Value Graph Test'
    g.labels = {
      0 => '1',
      1 => '2'
    }
    g.data('one', [1, 1])

    g.write('test/output/bar_one_value.png')

    assert_same_image('test/expected/bar_one_value.png', 'test/output/bar_one_value.png')
  end

  def test_negative
    g = Gruff::Bar.new
    g.title = 'Pos/Neg Bar Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])

    g.write('test/output/bar_pos_neg.png')

    assert_same_image('test/expected/bar_pos_neg.png', 'test/output/bar_pos_neg.png')
  end

  def test_nearly_zero
    g = Gruff::Bar.new
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
    g.write('test/output/bar_nearly_zero_max_10.png')

    assert_same_image('test/expected/bar_nearly_zero_max_10.png', 'test/output/bar_nearly_zero_max_10.png')
  end

  def test_y_axis_increment
    generate_with_y_axis_increment 2.0
    generate_with_y_axis_increment 1
    generate_with_y_axis_increment 5
    generate_with_y_axis_increment 20
  end

  def generate_with_y_axis_increment(increment)
    g = Gruff::Bar.new
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
    g.write("test/output/bar_y_increment_#{increment}.png")

    assert_same_image("test/expected/bar_y_increment_#{increment}.png", "test/output/bar_y_increment_#{increment}.png")
  end

  def test_custom_spacing
    g = Gruff::Bar.new
    g.spacing_factor = 0
    g.title = 'Zero spacing graph'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }

    g.data(:apples, [1, 5, 8, 4])
    g.data(:peaches, [4, 1, 2, 10])
    g.minimum_value = 0
    g.maximum_value = 10
    g.write('test/output/bar_zero_spacing.png')

    assert_same_image('test/expected/bar_zero_spacing.png', 'test/output/bar_zero_spacing.png')
  end

  def test_spacing_factor_does_not_accept_values_lt_0_and_gt_1
    g = Gruff::Bar.new

    assert_raises ArgumentError do
      g.spacing_factor = 1.01
    end

    assert_raises ArgumentError do
      g.spacing_factor = -0.01
    end
  end

  def test_custom_theme
    g = Gruff::Bar.new
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
    g.write('test/output/bar_themed.png')

    assert_same_image('test/expected/bar_themed.png', 'test/output/bar_themed.png')
  end

  def test_background_gradient_top_bottom
    g = Gruff::Bar.new
    g.title = 'Background gradient top to bottom'
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :top_bottom
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_top_bottom.png')

    assert_same_image('test/expected/bar_background_gradient_top_bottom.png', 'test/output/bar_background_gradient_top_bottom.png')
  end

  def test_background_gradient_bottom_top
    g = Gruff::Bar.new
    g.title = 'Background gradient top to bottom'
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :bottom_top
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_bottom_top.png')

    assert_same_image('test/expected/bar_background_gradient_bottom_top.png', 'test/output/bar_background_gradient_bottom_top.png')
  end

  def test_background_gradient_left_right
    g = Gruff::Bar.new
    g.title = 'Background gradient left to right'
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :left_right
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_left_right.png')

    assert_same_image('test/expected/bar_background_gradient_left_right.png', 'test/output/bar_background_gradient_left_right.png')
  end

  def test_background_gradient_right_left
    g = Gruff::Bar.new
    g.title = 'Background gradient right to left'
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :right_left
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_right_left.png')

    assert_same_image('test/expected/bar_background_gradient_right_left.png', 'test/output/bar_background_gradient_right_left.png')
  end

  def test_background_gradient_topleft_bottomright
    g = Gruff::Bar.new
    g.title = 'Background gradient top left to bottom right'
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :topleft_bottomright
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_topleft_bottomright.png')

    assert_same_image('test/expected/bar_background_gradient_topleft_bottomright.png', 'test/output/bar_background_gradient_topleft_bottomright.png')
  end

  def test_background_gradient_topright_bottomleft
    g = Gruff::Bar.new
    g.title = 'Background gradient top right to bottom left'
    g.title_font_size = 30
    g.theme = {
      background_colors: %w[#ff0000 #00ff00],
      background_direction: :topright_bottomleft
    }
    g.labels = @labels
    @datasets.each do |name, values|
      g.data(name, values)
    end
    g.minimum_value = 0
    write_test_file(g, 'bar_background_gradient_topright_bottomleft.png')

    assert_same_image('test/expected/bar_background_gradient_topright_bottomleft.png', 'test/output/bar_background_gradient_topright_bottomleft.png')
  end

  def test_legend_should_not_overlap
    g = Gruff::Bar.new(400)
    g.theme_37signals
    g.title = 'My Graph'
    g.data('Apples Oranges Watermelon Apples Oranges', [1, 2, 3, 4, 4, 3])
    g.data('Oranges', [4, 8, 7, 9, 8, 9])
    g.data('Watermelon', [2, 3, 1, 5, 6, 8])
    g.data('Peaches', [9, 9, 10, 8, 7, 9])
    g.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }
    g.write('test/output/bar_long_legend_text.png')

    assert_same_image('test/expected/bar_long_legend_text.png', 'test/output/bar_long_legend_text.png')
  end

  def test_july_enhancements
    g = Gruff::Bar.new(600)
    g.hide_legend = true
    g.title = 'Full speed ahead'
    g.labels = (0..10).reduce({}) { |memo, i| memo.merge({ i => (i * 10).to_s }) }
    g.data(:apples, (0..9).map { rand(20) / 10.0 })
    g.y_axis_increment = 1.0
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = 'Students'
    write_test_file(g, 'enhancements.png')

    assert_same_image('test/expected/enhancements.png', 'test/output/enhancements.png')
  end

  def test_bar_spacing
    g = setup_basic_graph
    g.bar_spacing = 0
    g.title = '100% spacing between bars'
    g.write('test/output/bar_spacing_full.png')

    assert_same_image('test/expected/bar_spacing_full.png', 'test/output/bar_spacing_full.png')

    g = setup_basic_graph
    g.bar_spacing = 0.5
    g.title = '50% spacing between bars'
    g.write('test/output/bar_spacing_half.png')

    assert_same_image('test/expected/bar_spacing_half.png', 'test/output/bar_spacing_half.png')

    g = setup_basic_graph
    g.bar_spacing = 1
    g.title = '0% spacing between bars'
    g.write('test/output/bar_spacing_none.png')

    assert_same_image('test/expected/bar_spacing_none.png', 'test/output/bar_spacing_none.png')
  end

  def test_set_label_stagger_height
    g = setup_long_labelled_graph
    g.title = 'Staggered labels'
    g.label_stagger_height = 30
    g.write('test/output/bar_set_label_stagger_height.png')

    assert_same_image('test/expected/bar_set_label_stagger_height.png', 'test/output/bar_set_label_stagger_height.png')
  end

  def test_set_label_max_size_and_label_truncation_style
    # Absolute trunc
    g = setup_long_labelled_graph
    g.title = 'Absolute truncation (13 chars)'
    g.label_max_size = 13
    g.label_truncation_style = :absolute
    g.write('test/output/bar_set_absolute_trunc.png')

    assert_same_image('test/expected/bar_set_absolute_trunc.png', 'test/output/bar_set_absolute_trunc.png')

    # Trailing Dots trunc
    g = setup_long_labelled_graph
    g.title = 'Trailing dots truncation (6 chars inc dots)'
    g.label_max_size = 6
    g.label_truncation_style = :trailing_dots
    g.write('test/output/bar_set_trailing_dots_trunc.png')

    assert_same_image('test/expected/bar_set_trailing_dots_trunc.png', 'test/output/bar_set_trailing_dots_trunc.png')
  end

  def test_bar_value_labels
    g = setup_basic_graph
    g.show_labels_for_bar_values = true
    g.write('test/output/bar_value_labels.png')

    assert_same_image('test/expected/bar_value_labels.png', 'test/output/bar_value_labels.png')
  end

  def test_label_format
    g = setup_basic_graph
    g.title = 'Label format'
    g.show_labels_for_bar_values = true
    g.label_formatting = lambda do |value|
      "V-#{value.to_i}"
    end
    g.y_axis_label_format = lambda do |value|
      "Y-#{value.to_i}"
    end

    g.write('test/output/bar_label_format.png')

    assert_same_image('test/expected/bar_label_format.png', 'test/output/bar_label_format.png')
  end

  def test_group_spacing
    g = setup_basic_graph
    g.group_spacing = 100
    g.write('test/output/bar_group_spacing.png')

    assert_same_image('test/expected/bar_group_spacing.png', 'test/output/bar_group_spacing.png')
  end

  def test_bar_negative_value_labels
    g = Gruff::Bar.new
    g.data :foo, [7, 56, -31.25]
    g.show_labels_for_bar_values = true
    g.write('test/output/bar_negative_value_labels.png')

    assert_same_image('test/expected/bar_negative_value_labels.png', 'test/output/bar_negative_value_labels.png')
  end

  def test_zero_marker_count
    g = setup_basic_graph
    g.marker_count = 0
    g.write('test/output/bar_zero_marker_count.png')

    assert_same_image('test/expected/bar_zero_marker_count.png', 'test/output/bar_zero_marker_count.png')
  end

  def test_zero_marker_shadow
    g = setup_basic_graph
    g.title = 'Bar Chart with Marker Shadow'
    g.marker_shadow_color = '#888888'
    g.write('test/output/bar_marker_shadow.png')

    assert_same_image('test/expected/bar_marker_shadow.png', 'test/output/bar_marker_shadow.png')
  end

  def test_axis_label_with_hide_line_markers
    g = setup_basic_graph
    g.title = 'Axis Label with Hide Line Markers'
    g.hide_line_markers = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/bar_axis_label_with_hide_line_markers.png')

    assert_same_image('test/expected/bar_axis_label_with_hide_line_markers.png', 'test/output/bar_axis_label_with_hide_line_markers.png')
  end

  def test_axis_label_with_legend_at_bottom
    g = setup_basic_graph
    g.title = 'Axis Label with Legend at Bottom'
    g.legend_at_bottom = true
    g.x_axis_label = 'x_axis_label'
    g.y_axis_label = 'y_axis_label'
    g.write('test/output/bar_axis_label_with_legend_at_bottom.png')

    assert_same_image('test/expected/bar_axis_label_with_legend_at_bottom.png', 'test/output/bar_axis_label_with_legend_at_bottom.png')
  end

  def test_draw_twice
    g = setup_basic_graph
    g.show_labels_for_bar_values = true
    g.draw
    g.draw

    pass
  end

  def test_empty_data
    g = Gruff::Bar.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [nil, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.write('test/output/bar_empty_data.png')

    assert_same_image('test/expected/bar_empty_data.png', 'test/output/bar_empty_data.png')
  end

  def test_duck_typing
    g = Gruff::Bar.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/bar_duck_typing.png')

    assert_same_image('test/expected/bar_duck_typing.png', 'test/output/bar_duck_typing.png')
  end

protected

  def setup_basic_graph(size = 800)
    g = Gruff::Bar.new(size)
    g.title = 'My Bar Graph'
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

  def setup_long_labelled_graph(size = 500)
    g = Gruff::Bar.new(size)
    g.title = 'A Graph for All Seasons'
    g.labels = {
      0 => 'January was a cold one',
      1 => 'February is little better',
      2 => 'March will bring me hares',
      3 => 'April and I\'m a fool'
    }

    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g
  end
end

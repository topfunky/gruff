#!/usr/bin/ruby

require File.dirname(__FILE__) +  '/gruff_test_case'

class TestGruffLine < GruffTestCase
  def test_x_axis_on_top
    g = setup_basic_graph('800x500')
    g.title = 'TOP x axis chart'
    g.legend_at_bottom = true
    g.x_axis_on_top = true
    g.write('test/output/line_x_on_top.png')
  end

  def test_side_bar_x_axis_on_top
    g = Gruff::SideBar.new('800x400')
    g.title = 'TOP X Side Bar Graph'
    g.labels = @labels
    @datasets.each do |data|
      g.data(data[0], data[1][0])
    end
    g.minimum_value = 0
    g.maximum_value = 100
    g.bar_spacing = 0.5
    g.hide_legend = true
    g.label_formatting = '%.1f%%'
    g.marker_format = '%.0f%%'
    g.marker_font_size = 15
    g.show_labels_for_bar_values = true
    g.top_margin = 0
    g.x_axis_on_top = true
    g.write('test/output/sidebar_x_on_top.png')
  end

  def test_bar_graph_x_axis_on_top
    g = Gruff::Bar.new('400x600')
    g.title = 'TOP X Bar Graph'
    g.labels = @labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.minimum_value = 0
    g.maximum_value = 100
    g.bar_spacing = 0.5
    g.hide_legend = true
    g.label_formatting = '%.1f%%'
    g.marker_format = '%.0f%%'
    g.marker_font_size = 15
    g.show_labels_for_bar_values = true
    g.top_margin = 0
    g.x_axis_on_top = true
    g.write('test/output/bar_x_on_top.png')
  end

  def test_line_bar_x_axis_on_top
    @datasets = [
        [:Jimmy, [25, 36, 86, 39]],
        [:Charles, [80, 54, 67, 54]],
        [:Julie, [22, 29, 35, 38]],
        [:Philip, [80, 34, 23, 12]]
    #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
    # [:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
    #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
    ]

    g = Gruff::BarNLine.new(800)
    g.title = 'Bar and Line (50% space)'
    g.labels = {
        0 => '5/6',
        1 => '5/15',
        2 => '5/24',
        3 => '5/30',
    }
    @datasets.each_with_index do |data, idx|
      if idx > 1
        g.data_line(data[0], data[1])
        next
      end
      g.data(data[0], data[1])
    end
    g.bar_spacing = 0.5
    g.data_column_spacing = 0.5
    g.minimum_value = 0
    g.x_axis_on_top = true

    g.write('test/output/bar_and_line_top_x_axis.png')


    g = Gruff::BarNLine.new(800)
    g.title = 'Bar and Line (right Y)'

    g.labels = {
        0 => '5/6',
        1 => '5/15',
        2 => '5/24',
        3 => '5/30',
    }
    @datasets.each_with_index do |data, idx|
      if idx > 1
        g.data_line(data[0], data[1])
        next
      end
      g.data(data[0], data[1])
    end
    g.minimum_value = 0

    g.right_y_axis = Gruff::Axis.new
    g.right_y_axis.label = 'the perc'
    g.right_y_axis.label_color = 'yellow'
    g.right_y_axis.line_color = 'grey'
    g.right_y_axis.maximum_value = 100
    g.right_y_axis.minimum_value = 0
    g.right_y_axis.format = '%.0f%%'
    g.right_y_axis.skip_lines = [0]
    g.right_y_axis.count = 5
    g.right_y_axis.stroke_dash = [3, 5]
    g.right_y_axis.stroke_opacity = 0.4
    g.x_axis_on_top = true

    g.write('test/output/bar_and_line_top_x_axis_right_y.png')
  end

end

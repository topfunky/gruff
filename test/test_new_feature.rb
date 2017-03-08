#!/usr/bin/ruby

require_relative 'gruff_test_case'

class TestNewFeature < GruffTestCase

  # TODO Delete old output files once when starting tests

  def setup
    super
    @datasets = [
        [:Jimmy, [25, 36, 86, 39]],
        [:Charles, [80, 54, 67, 54]],
        [:Julie, [22, 29, 35, 38]],
    #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
    #[:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
    #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
    ]
  end

  def test_bar_formatted_marker_label
    g = setup_basic_bar_graph
    g.title = 'Bar Chart (marker %)'
    g.marker_format = '%.0f%%'
    g.write('test/output/bar_marker_format_percent.png')
  end

  def test_bar_secondary_y_axis
    g = setup_basic_bar_graph
    g.title = 'Bar Chart (right Y)'
    g.secondary_y_axis = {
        label: nil,
        label_color: 'yellow',
        label_font: nil,
        line_color: 'grey',
        font_size: 21,
        maximum_value: 100,
        minimum_value: 0,
        format: '%.0f%%',
        stroke_dash: [3, 5],
        stroke_opacity: 0.4,
        skip_lines: [0, 5],
        count: 5
      }
    g.write('test/output/bar_with_secondary_y.png')
  end

  def test_line_formatted_marker
    g = setup_basic_line_graph(800)
    g.title = 'Line Chart (marker percent)'
    g.marker_format = '%.0f%%'

    g.write('test/output/line_marker_format_percent.png')
  end

  def test_line_secondary_y_axis
    g = setup_basic_line_graph(800)
    g.title = 'Line Chart (right Y)'
    g.secondary_y_axis = {
        label: nil,
        label_color: 'yellow',
        label_font: nil,
        line_color: 'grey',
        font_size: 21,
        maximum_value: 100,
        minimum_value: 0,
        format: '%.0f%%',
        stroke_dash: [3, 5],
        stroke_opacity: 0.4,
        skip_lines: [0, 5],
        count: 5
      }

    g.write('test/output/line_with_secondary_y.png')
  end

  protected

  def setup_basic_bar_graph(size=800)
    g = Gruff::Bar.new(size)
    g.title = 'My Bar Graph'
    g.labels = {
        0 => '5/6',
        1 => '5/15',
        2 => '5/24',
        3 => '5/30',
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g
  end

  def setup_basic_line_graph(size=800)
    g = Gruff::Line.new(size)
    g.labels = {
        0 => '5/6',
        10 => '5/15',
        20 => '5/24',
        30 => '5/30',
        40 => '6/4',
        50 => '6/16'
    }
    %w{jimmy jane philip}.each do |student_name|
      g.data(student_name, (0..10).collect { |i| rand 100 })
    end
    g
  end
end
#!/usr/bin/ruby

require File.dirname(__FILE__) + '/gruff_test_case'

class TestBarAndLine < GruffTestCase

  # TODO Delete old output files once when starting tests

  def setup
    super
    @datasets = [
        [:Jimmy, [25, 36, 86, 39]],
        [:Charles, [80, 54, 67, 54]],
        [:Julie, [22, 29, 35, 38]],
        [:Philip, [80, 34, 23, 12]]
    #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
    # [:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
    #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
    ]
  end

  def test_basic_bar_and_line
    g = Gruff::BarNLine.new(800)
    g.title = 'Bar and Line Graph'
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

    g.write('test/output/bar_and_line_basic.png')

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

    g.write('test/output/bar_and_line_50perc_space.png')
  end

  def test_basic_bar_n_line_right_y
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

    g.write('test/output/bar_and_line_w_right_y.png')
  end

  def test_basic_bar_n_line_right_y_ref_lines
    g = Gruff::BarNLine.new(800)
    g.title = 'Bar and Line (right Y, ref lines)'
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

    g.reference_line_default_width = 1
    g.reference_lines[:baseline]  = { :value => 20 }
    g.reference_lines[:lots]      = { :value => 49 }
    g.reference_lines[:little]    = { :value => 85 }
    g.reference_lines[:horiz_one] = { :index => 1, :color => 'green' }
    g.reference_lines[:horiz_two] = { :index => 3, :color => 'green' }

    g.write('test/output/bar_and_line_w_right_y_w_ref_lines.png')
  end
end
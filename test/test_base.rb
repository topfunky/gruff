#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffBase < GruffTestCase
  def setup
    @sample_numeric_labels = {
      0 => 6,
      1 => 15,
      2 => 24,
      3 => 30,
      4 => 4,
      5 => 12,
      6 => 21,
      7 => 28
    }
  end

  def test_labels_can_be_any_object
    g = Gruff::Bar.new
    g.title = 'Bar Graph With Manual Colors'
    g.legend_margin = 50
    g.labels = @sample_numeric_labels
    g.data(:Art, [0, 5, 8, 15], '#990000')
    g.data(:Philosophy, [10, 3, 2, 8], '#009900')
    g.data(:Science, [2, 15, 8, 11], '#990099')

    g.minimum_value = 0

    g.write('test/output/bar_object_labels.png')
  end

  def test_data_given
    graph = Gruff::Bar.new
    refute(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]
    assert(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]
    graph.minimum_value = 10
    graph.maximum_value = -10
    refute(graph.__send__(:data_given?))

    graph = Gruff::Bar.new
    graph.data :foo, [1, 2, 3]
    graph.minimum_value = 0
    graph.maximum_value = 5
    assert(graph.__send__(:data_given?))
  end

  def test_minimum
    g = Gruff::Bar.new
    g.minimum_value = 0
    g.data :hora, [6, 0, 0, 0, 0, 2, 8]

    g = Gruff::Bar.new
    g.data :hora, [6, 0, 0, 0, 0, 2, 8]
    g.minimum_value = 0

    pass
  end

  def test_maximum
    g = Gruff::Bar.new
    g.maximum_value = 0
    g.data :hora, [6, 0, 0, 0, 0, 2, 8]

    g = Gruff::Bar.new
    g.data :hora, [6, 0, 0, 0, 0, 2, 8]
    g.maximum_value = 0

    pass
  end
end

#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffArea < GruffTestCase

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]],
      [:Charles, [80, 54, 67, 54, 68, 70, 90, 95]],
      [:Julie, [22, 29, 35, 38, 36, 40, 46, 57]],
      [:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
      [:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
      ["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
      ]
    @sample_labels = {
        0 => '5/6', 
        1 => '5/15', 
        2 => '5/24', 
        3 => '5/30', 
        4 => '6/4', 
        5 => '6/12', 
        6 => '6/21', 
        7 => '6/28', 
      }      

  end
  
  def test_area_graph
    g = Gruff::Area.new
    g.title = "Visual Multi-Area Graph Test"
    g.labels = {
      0 => '5/6', 
      2 => '5/15', 
      4 => '5/24', 
      6 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/area_keynote.png")
  end
  
  def test_resize
    g = Gruff::Area.new(400)
    g.title = "Small Size Multi-Area Graph Test"
    g.labels = {
      0 => '5/6', 
      2 => '5/15', 
      4 => '5/24', 
      6 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/area_keynote_small.png")
  end
  
  def test_many_datapoints
    g = Gruff::Area.new
    g.title = "Many Multi-Area Graph Test"
    g.labels = {
      0 => 'June', 
      10 => 'July', 
      30 => 'August', 
      50 => 'September', 
    }
    g.data('many points', (0..50).collect {|i| rand(100) })

    # Default theme
    g.write("test/output/area_many.png")
  end

  def test_many_areas_graph_small
    g = Gruff::Area.new(400)
    g.title = "Many Values Area Test 400px"
    g.labels = {
      0 => '5/6', 
      10 => '5/15', 
      20 => '5/24', 
      30 => '5/30', 
      40 => '6/4', 
      50 => '6/16'
    }
    %w{jimmy jane philip arthur julie bert}.each do |student_name|
      g.data(student_name, (0..50).collect { |i| rand 100 })
    end

    # Default theme
    g.write("test/output/area_many_areas_small.png")
  end

  def test_area_graph_tiny
    g = Gruff::Area.new(300)
    g.title = "Area Test 300px"
    g.labels = {
      0 => '5/6', 
      10 => '5/15', 
      20 => '5/24', 
      30 => '5/30', 
      40 => '6/4', 
      50 => '6/16'
    }
    %w{jimmy jane philip arthur julie bert}.each do |student_name|
      g.data(student_name, (0..50).collect { |i| rand 100 })
    end

    # Default theme
    g.write("test/output/area_tiny.png")
  end

  def test_wide
    g = setup_basic_graph('800x400')
    g.title = "Area Wide"
    g.write("test/output/area_wide.png")
  end

protected
  
  def setup_basic_graph(size=800)
    g = Gruff::Area.new(size)
    g.title = "My Graph Title"
    g.labels = @sample_labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    return g
  end
  
end

#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffNet < GruffTestCase

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
    
  def test_net_small_values    
    @datasets = [
      [:small, [0.1, 0.14356, 0.0, 0.5674839, 0.456]],
      [:small2, [0.2, 0.3, 0.1, 0.05, 0.9]]
      ]

    g = Gruff::Net.new
    g.title = "Small Values Net Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/net_small.png")

    g = Gruff::Net.new(400)
    g.title = "Small Values Net Graph Test 400px"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/net_small_small.png")
  end

  def test_net_starts_with_zero
    @datasets = [
      [:first0, [0, 5, 10, 8, 18]],
      [:normal, [1, 2, 3, 4, 5]]
      ]

    g = Gruff::Net.new
    g.title = "Small Values Net Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/net_small_zero.png")

    g = Gruff::Net.new(400)
    g.title = "Small Values Net Graph Test 400px"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/net_small_small_zero.png")
  end

    
  def test_net_large_values    
    @datasets = [
      [:large, [100_005, 35_000, 28_000, 27_000]],
      [:large2, [35_000, 28_000, 27_000, 100_005]],
      [:large3, [28_000, 27_000, 100_005, 35_000]],
      [:large4, [1_238, 39_092, 27_938, 48_876]]
      ]

    g = Gruff::Net.new
    g.title = "Very Large Values Net Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write("test/output/net_large.png")
  end
    
  def test_many_datapoints
    g = Gruff::Net.new
    g.title = "Many Multi-Net Graph Test"
    g.labels = {
      0 => 'June', 
      10 => 'July', 
      30 => 'August', 
      50 => 'September', 
    }
    g.data('many points', (0..50).collect {|i| rand(100) })

    # Default theme
    g.write("test/output/net_many.png")
  end


  def test_similar_high_end_values
    g = Gruff::Net.new
    g.title = "Similar High End Values Test"
    g.data('similar points', %w(29.43 29.459 29.498 29.53 29.548 29.589 29.619 29.66 29.689 29.849 29.878 29.74 29.769 29.79 29.808 29.828).collect {|i| i.to_f} )

    # Default theme
    g.write("test/output/net_similar_high_end_values.png")    
  end

  def test_many_nets_graph_small
    g = Gruff::Net.new(400)
    g.title = "Many Values Net Test 400px"
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
    g.write("test/output/net_many_nets_small.png")
  end

  def test_dots_graph_tiny
    g = Gruff::Net.new(300)
    g.title = "Dots Test 300px"
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
    g.write("test/output/net_dots_tiny.png")
  end

  def test_no_data
    g = Gruff::Net.new(400)
    g.title = "No Data"
    # Default theme
    g.write("test/output/net_no_data.png")
    
    g = Gruff::Net.new(400)
    g.title = "No Data Title"
    g.no_data_message = 'There is no data'
    g.write("test/output/net_no_data_msg.png")
  end


  def test_all_zeros
    g = Gruff::Net.new(400)
    g.title = "All Zeros"

    g.data(:gus, [0,0,0,0])

    # Default theme
    g.write("test/output/net_no_data_other.png")    
  end

  def test_no_title
    g = Gruff::Net.new(400)
    g.labels = @sample_labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write("test/output/net_no_title.png")
  end

  def test_no_net_markers
    g = setup_basic_graph(400)
    g.title = "No Net Markers"
    g.hide_line_markers = true
    g.write("test/output/net_no_net_markers.png")    
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = "No Legend"
    g.hide_legend = true
    g.write("test/output/net_no_legend.png")
  end

  def test_nothing_but_the_graph
    g = setup_basic_graph(400)
    g.title = "THIS TITLE SHOULD NOT DISPLAY!!!"
    g.hide_line_markers = true
    g.hide_legend = true
    g.hide_title = true
    g.write("test/output/net_nothing_but_the_graph.png")    
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = "Wide Graph"
    g.write("test/output/net_wide_graph.png")    

    g = setup_basic_graph('400x200')
    g.title = "Wide Graph Small"
    g.write("test/output/net_wide_graph_small.png")
  end

protected

  def setup_basic_graph(size=800)
    g = Gruff::Net.new(size)
    g.title = "My Graph Title"
    g.labels = @sample_labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    return g
  end
  
end

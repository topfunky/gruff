#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffSideStackedBar < GruffTestCase

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]],
      #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
      #[:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
      #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
      ]
    @sample_labels = {
        0 => '5/6', 
        1 => '5/15', 
        2 => '5/24'
      }      

  end

  def test_bar_graph
    g = Gruff::SideStackedBar.new
    g.title = "Visual Stacked Bar Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write "test/output/side_stacked_bar_keynote.png"
  end


  def test_bar_graph_small
    g = Gruff::SideStackedBar.new(400)
    g.title = "Visual Stacked Bar Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write "test/output/side_stacked_bar_keynote_small.png"
  end

  def test_wide
    g = setup_basic_graph('800x400')
    g.title = "Wide SSBar"
    g.write "test/output/side_stacked_bar_wide.png"
  end

  def test_should_space_long_left_labels_appropriately
    g = Gruff::SideStackedBar.new
    g.title = "Stacked Bar Long Label"
    g.labels = {
      0 => 'September', 
      1 => 'Oct', 
      2 => 'Nov', 
      3 => 'Dec', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write "test/output/side_stacked_bar_long_label.png"
  end
  
  def test_bar_labels
     g = Gruff::SideStackedBar.new
     g.title = "Stacked Bar Long Label"
     g.labels = {
       0 => 'September', 
       1 => 'Oct', 
       2 => 'Nov', 
       3 => 'Dec', 
     }
     @datasets.each do |data|
       g.data(data[0], data[1])
     end
     g.show_labels_for_bar_values = true
     g.write "test/output/side_stacked_bar_labels.png"
  end

protected

  def setup_basic_graph(size=800)
    g = Gruff::SideStackedBar.new(size)
    g.title = "My Graph Title"
    g.labels = @sample_labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    return g
  end

end


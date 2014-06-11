#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffStackedBar < GruffTestCase

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]],
      ]
    @sample_labels = {
        0 => '5/6', 
        1 => '5/15', 
        2 => '5/24'
      }      

  end

  def test_bar_graph
    g = Gruff::StackedBar.new
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
    g.write "test/output/stacked_bar_keynote.png"
  end


  def test_bar_graph_small
    g = Gruff::StackedBar.new(400)
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
    g.write "test/output/stacked_bar_keynote_small.png"
  end

  def test_bar_graph_segment_spacing
    g = Gruff::StackedBar.new
    g.title = "Visual Stacked Bar Graph Test"
    g.segment_spacing = 0
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30',
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write "test/output/stacked_bar_keynote_no_space.png"
  end
  
end

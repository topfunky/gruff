#!/usr/bin/ruby

require File.dirname(__FILE__) + '/gruff_test_case'

class TestGruffStackedArea < GruffTestCase

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

  def test_area_graph
    g = Gruff::StackedArea.new
    g.title = 'Visual Stacked Area Graph Test'
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write 'test/output/stacked_area_keynote.png'
  end


  def test_area_graph_small
    g = Gruff::StackedArea.new(400)
    g.title = 'Visual Stacked Area Graph Test'
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write 'test/output/stacked_area_keynote_small.png'
  end
  
end

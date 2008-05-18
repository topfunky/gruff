#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffScatter < Test::Unit::TestCase
  
  def setup
    #~ @datasets = [
      #~ [:Chuck, [1, 2, 3, 4, 5]], 
      #~ [:Brown, [5, 10, 15, 20, 25]], 
      #~ [:Lucy, [10, 20, 30, 40, 50]]
      #~ ]
    @datasets = [
      ['Chuck', [20,10,5], [5,10,20] ]
    ]
  end
  
  def test_scatter_graph
    g = setup_basic_graph
    g.title = "Best Graph Ever"
    g.write("test/output/scatter_basic.png")
  end
  
protected 
  
  def setup_basic_graph(size=800)
    g = Gruff::Scatter.new(size)
    g.title = "Rad Graph"
    @datasets.each do |data|
      g.data(data[0], data[1], data[2])
    end
    g
  end
  
end # end GruffTestCase
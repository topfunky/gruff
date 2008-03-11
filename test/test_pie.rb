#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffPie < GruffTestCase

  def setup
    @datasets = [
      [:Darren, [25]],
      [:Chris, [80]],
      [:Egbert, [22]],
      [:Adam, [95]],
      [:Bill, [90]],
      ["Frank", [5]],
      ["Zero", [0]],
      ]
  end
  
  def test_pie_graph
    g = Gruff::Pie.new
    g.title = "Visual Pie Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/pie_keynote.png")
  end

  def test_pie_graph_greyscale
    g = Gruff::Pie.new
    g.title = "Greyscale Pie Graph Test"
    g.theme_greyscale
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/pie_grey.png")
  end

  def test_pie_graph_pastel
    g = Gruff::Pie.new
    g.theme_pastel
    g.title = "Pastel Pie Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/pie_pastel.png")
  end


  def test_pie_graph_small
    g = Gruff::Pie.new(400)
    g.title = "Visual Pie Graph Test Small"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write("test/output/pie_keynote_small.png")
  end

  def test_pie_graph_nearly_equal
    g = Gruff::Pie.new
    g.title = "Pie Graph Nearly Equal"
    
    g.data(:Blake, [41])
    g.data(:Aaron, [42])
#    g.data(:Grouch, [40])
#    g.data(:Snuffleupagus, [43])

    g.write("test/output/pie_nearly_equal.png")
  end

  def test_pie_graph_equal
    g = Gruff::Pie.new
    g.title = "Pie Graph Equal"
        
    g.data(:Bert, [41])
    g.data(:Adam, [41])

    g.write("test/output/pie_equal.png")
  end

  def test_pie_graph_zero
    g = Gruff::Pie.new
    g.title = "Pie Graph One Zero"
        
    g.data(:Bert, [0])
    g.data(:Adam, [1])

    g.write("test/output/pie_zero.png")
  end


  def test_pie_graph_one_val
    g = Gruff::Pie.new
    g.title = "Pie Graph One Val"
        
    g.data(:Bert, 53)
    g.data(:Adam, 29)

    g.write("test/output/pie_one_val.png")
  end


  def test_wide
    g = setup_basic_graph('800x400')
    g.title = "Wide Pie"
    g.write("test/output/pie_wide.png")
  end

  def test_label_size
    g = setup_basic_graph()
    g.title = "Pie With Small Legend"
    g.legend_font_size = 10
    g.write("test/output/pie_legend.png")
    
    g = setup_basic_graph(400)
    g.title = "Small Pie With Small Legend"
    g.legend_font_size = 10
    g.write("test/output/pie_legend_small.png")
  end

  
  def test_tiny_simple_pie
    @datasets = (1..5).map {|n| ['Auto', [rand(100)]]}

    g = setup_basic_graph 200
    g.hide_legend = true
    g.hide_title = true
    g.hide_line_numbers = true
  
    g.marker_font_size = 40.0
    g.minimum_value = 0.0
    
    write_test_file g, "pie_simple.png"
  end
  
protected

  def setup_basic_graph(size=800)
    g = Gruff::Pie.new(size)
    g.title = "My Graph Title"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    return g
  end
  
end

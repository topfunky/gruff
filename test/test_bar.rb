#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffBar < GruffTestCase

  # TODO Delete old output files once when starting tests

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]],
      #[:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
      #[:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
      #["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
      ]
  end

  def test_bar_graph
    g = setup_basic_graph
    g.title = "Bar Graph Test"
    g.write("test/output/bar_keynote.png")
        
    g = setup_basic_graph
    g.title = "Visual Multi-Line Bar Graph Test"
    g.theme_rails_keynote
    g.write("test/output/bar_rails_keynote.png")
    
    g = setup_basic_graph
    g.title = "Visual Multi-Line Bar Graph Test"
    g.theme_odeo
    g.write("test/output/bar_odeo.png")
  end

  def test_bar_graph_set_colors
    g = Gruff::Bar.new
    g.title = "Bar Graph With Manual Colors"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:Art, [0, 5, 8, 15], '#990000')
    g.data(:Philosophy, [10, 3, 2, 8], '#009900')
    g.data(:Science, [2, 15, 8, 11], '#990099')

    g.minimum_value = 0
        
    g.write("test/output/bar_manual_colors.png")
  end

  def test_bar_graph_small
    g = Gruff::Bar.new(400)
    g.title = "Visual Multi-Line Bar Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write("test/output/bar_keynote_small.png")
  end

  # Somewhat worthless test. Should an error be thrown?
  # def test_nil_font
  #   g = setup_basic_graph 400
  #   g.title = "Nil Font"
  #   g.font = nil
  #   g.write "test/output/bar_nil_font.png"
  # end


  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = "No Line Markers"
    g.hide_line_markers = true
    g.write("test/output/bar_no_line_markers.png")    
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = "No Legend"
    g.hide_legend = true
    g.write("test/output/bar_no_legend.png")    
  end

  def test_no_title
    g = setup_basic_graph(400)
    g.title = "No Title"
    g.hide_title = true
    g.write("test/output/bar_no_title.png")    
  end
  
  def test_no_title_or_legend
    g = setup_basic_graph(400)
    g.title = "No Title or Legend"
    g.hide_legend = true
    g.hide_title = true
    g.write("test/output/bar_no_title_or_legend.png")    
  end

  def test_set_marker_count
    g = setup_basic_graph(400)
    g.title = "Set marker"
    g.marker_count = 10
    g.write("test/output/bar_set_marker.png")
  end

  def test_set_legend_box_size
    g = setup_basic_graph(400)
    g.title = "Set Small Legend Box Size"
    g.legend_box_size = 10.0
    g.write("test/output/bar_set_legend_box_size_sm.png")
    
    g = setup_basic_graph(400)
    g.title = "Set Large Legend Box Size"
    g.legend_box_size = 50.0
    g.write("test/output/bar_set_legend_box_size_lg.png")
  end

  def test_x_y_labels
    g = setup_basic_graph(400)
    g.title = "X Y Labels"
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = "Students"
    g.write("test/output/bar_x_y_labels.png")    
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = "Wide Graph"
    g.write("test/output/bar_wide_graph.png")    

    g = setup_basic_graph('400x200')
    g.title = "Wide Graph Small"
    g.write("test/output/bar_wide_graph_small.png")
  end


  def test_tall_graph
    g = setup_basic_graph('400x600')
    g.title = "Tall Graph"
    g.write("test/output/bar_tall_graph.png")

    g = setup_basic_graph('200x400')
    g.title = "Tall Graph Small"
    g.write("test/output/bar_tall_graph_small.png")
  end


  def test_one_value
    g = Gruff::Bar.new
    g.title = "One Value Graph Test"
    g.labels = {
      0 => '1', 
      1 => '2'
    }
    g.data('one', [1,1])

    g.write("test/output/bar_one_value.png")
  end


  def test_negative
    g = Gruff::Bar.new
    g.title = "Pos/Neg Bar Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])

    g.write("test/output/bar_pos_neg.png")
  end


  def test_nearly_zero
    g = Gruff::Bar.new
    g.title = "Nearly Zero Graph"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:apples, [1, 2, 3, 4])
    g.data(:peaches, [4, 3, 2, 1])
    g.minimum_value = 0
    g.maximum_value = 10
    g.write("test/output/bar_nearly_zero_max_10.png")
  end

  def test_y_axis_increment
    generate_with_y_axis_increment 2.0
    generate_with_y_axis_increment 1
    generate_with_y_axis_increment 5
    generate_with_y_axis_increment 20
  end

  def generate_with_y_axis_increment(increment)
    g = Gruff::Bar.new
    g.title = "Y Axis Set to #{increment}"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.y_axis_increment = increment
    g.data(:apples, [1, 0.2, 0.5, 0.7])
    g.data(:peaches, [2.5, 2.3, 2, 6.1])
    g.write("test/output/bar_y_increment_#{increment}.png")
  end


  def test_custom_theme
    g = Gruff::Bar.new
    g.title = "Custom Theme"
    g.font = File.expand_path('CREABBRG.TTF', ENV['MAGICK_FONT_PATH'])
    g.title_font_size = 60
    g.legend_font_size = 32
    g.marker_font_size = 32
    g.theme = {
      :colors => %w(#efd250 #666699 #e5573f #9595e2),
      :marker_color => 'white',
      :font_color => 'blue',
      :background_image => "assets/pc306715.jpg"
    }
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:vancouver, [1, 2, 3, 4])
    g.data(:seattle, [2, 4, 6, 8])
    g.data(:portland, [3, 1, 7, 3])
    g.data(:victoria, [4, 3, 5, 7])
    g.minimum_value = 0
    g.write("test/output/bar_themed.png")
  end

  def test_july_enhancements
    g = Gruff::Bar.new(600)
    g.hide_legend = true
    g.title = "Full speed ahead"
    g.labels = (0..10).inject({}) { |memo, i| memo.merge({ i => (i*10).to_s}) }
    g.data(:apples, (0..9).map { rand(20)/10.0 })
    g.y_axis_increment = 1.0
    g.x_axis_label = 'Score (%)'
    g.y_axis_label = 'Students'
    write_test_file g, 'enhancements.png'
  end


protected

  def setup_basic_graph(size=800)
    g = Gruff::Bar.new(size)
    g.title = "My Bar Graph"
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
  
end


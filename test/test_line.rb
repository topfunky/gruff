#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffLine < GruffTestCase

  # TODO Delete old output files once when starting tests

  def test_should_render_with_transparent_theme
    g = Gruff::Line.new(400)
    g.title = "Transparent Background"
    g.theme = {
      :colors => ['black', 'grey'],
      :marker_color => 'grey',
      :font_color => 'black',
      :background_colors => 'transparent'
    }
    
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])
    g.write("test/output/line_transparent.png")
  end
  
  def test_line_graph_with_themes
    line_graph_with_themes()
    line_graph_with_themes(400)
  end
  
  def test_one_value
    g = Gruff::Line.new
    g.title = "One Value"
    g.labels = {
      0 => '1', 
      1 => '2'
    }
    g.data('one', 1)

    g.write("test/output/line_one_value.png")
  end

  def test_one_value_array
    g = Gruff::Line.new
    g.title = "One Value in an Array"
    g.labels = {
      0 => '1', 
      1 => '2'
    }
    g.data('one', [1])

    g.write("test/output/line_one_value_array.png")
  end


  def test_should_not_hang_with_0_0_100
    g = Gruff::Line.new(320)
    g.title = "Hang Value Graph Test"
    g.data('test', [0,0,100])

    g.write("test/output/line_hang_value.png")
  end

  # TODO
  # def test_fix_crash
  #   g = Gruff::Line.new(370)
  #   g.title = "Crash Test"
  #   g.data "ichi", [5]
  #   g.data "ni", [0]
  #   g.data "san", [0]
  #   g.data "shi", [0]
  #   g.write("test/output/line_crash_fix_test.png")
  # end

  
  def test_line_small_values    
    @datasets = [
      [:small, [0.1, 0.14356, 0.0, 0.5674839, 0.456]],
      [:small2, [0.2, 0.3, 0.1, 0.05, 0.9]]
      ]

    g = Gruff::Line.new
    g.title = "Small Values Line Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_small.png")

    g = Gruff::Line.new(400)
    g.title = "Small Values Line Graph Test 400px"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_small_small.png")
  end

  def test_line_starts_with_zero
    @datasets = [
      [:first0, [0, 5, 10, 8, 18]],
      [:normal, [1, 2, 3, 4, 5]]
      ]

    g = Gruff::Line.new
    g.title = "Small Values Line Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_small_zero.png")

    g = Gruff::Line.new(400)
    g.title = "Small Values Line Graph Test 400px"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_small_small_zero.png")
  end

    
  def test_line_large_values    
    @datasets = [
      [:large, [100_005, 35_000, 28_000, 27_000]],
      [:large2, [35_000, 28_000, 27_000, 100_005]],
      [:large3, [28_000, 27_000, 100_005, 35_000]],
      [:large4, [1_238, 39_092, 27_938, 48_876]]
      ]

    g = Gruff::Line.new
    g.title = "Very Large Values Line Graph Test"
    g.baseline_value = 50_000
    g.baseline_color = 'green'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write("test/output/line_large.png")
  end
    
  # def test_long_title
  #   
  # end
  # 
  # def test_add_colors
  #   
  # end
  # 

  def test_request_too_many_colors
    g = Gruff::Line.new
    g.title = "More Sets Than in Color Array"
#     g.theme = {} # Sets theme with only black and white
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    @datasets.each do |data|
      g.data("#{data[0]}-B", data[1].map {|d| d + 20})
    end
    g.write("test/output/line_more_sets_than_colors.png")    
  end
  
  # 
  # def test_add_data
  #   
  # end

  def test_many_datapoints
    g = Gruff::Line.new
    g.title = "Many Multi-Line Graph Test"
    g.labels = {
      0 => 'June', 
      10 => 'July', 
      30 => 'August', 
      50 => 'September', 
    }
    g.data('many points', (0..50).collect {|i| rand(100) })
    g.x_axis_label = "Months"

    # Default theme
    g.write("test/output/line_many.png")
  end


  def test_similar_high_end_values
    @dataset = %w(29.43 29.459 29.498 29.53 29.548 29.589 29.619 29.66 29.689 29.849 29.878 29.74 29.769 29.79 29.808 29.828).collect {|i| i.to_f}

    g = Gruff::Line.new
    g.title = "Similar High End Values Test"
    g.data('similar points', @dataset )
    g.write("test/output/line_similar_high_end_values.png")
    
    g = Gruff::Line.new
    g.title = "Similar High End Values With Floor"
    g.data('similar points', @dataset )
    g.minimum_value = 0
    g.y_axis_label = "Barometric Pressure"
    g.write("test/output/line_similar_high_end_values_with_floor.png")
  end

  def test_many_lines_graph_small
    g = Gruff::Line.new(400)
    g.title = "Many Values Line Test 400px"
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
    g.write("test/output/line_many_lines_small.png")
  end

  def test_graph_tiny
    g = Gruff::Line.new(300)
    g.title = "Tiny Test 300px"
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
    g.write("test/output/line_tiny.png")
  end

  def test_no_data
    g = Gruff::Line.new(400)
    g.title = "No Data"
    # Default theme
    g.write("test/output/line_no_data.png")
    
    g = Gruff::Line.new(400)
    g.title = "No Data Title"
    g.no_data_message = 'There is no data'
    g.write("test/output/line_no_data_msg.png")
  end


  def test_all_zeros
    g = Gruff::Line.new(400)
    g.title = "All Zeros"

    g.data(:gus, [0,0,0,0])

    # Default theme
    g.write("test/output/line_no_data_other.png")    
  end


  def test_some_nil_points
    g = Gruff::Line.new
    g.title = "Some Nil Points"

    @datasets = [
      [:data1, [1, 2, 3, nil, 3, 5, 6]],
      [:data2, [5, nil, nil, nil, nil, nil, 5]],
      [:data3, [4, nil, 2, 1, 0]],
      [:data4, [nil, nil, 3, 1, 2]]
      ]

    @datasets.each do |data|
      g.data(*data)
    end

    # Default theme
    g.write("test/output/line_some_nil_points.png")    
  end

  def test_no_title
    g = Gruff::Line.new(400)
    g.labels = @labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write("test/output/line_no_title.png")
  end

  def test_no_line_markers
    g = setup_basic_graph(400)
    g.title = "No Line Markers"
    g.hide_line_markers = true
    g.write("test/output/line_no_line_markers.png")    
  end

  def test_no_legend
    g = setup_basic_graph(400)
    g.title = "No Legend"
    g.hide_legend = true
    g.write("test/output/line_no_legend.png")
  end

  def test_nothing_but_the_graph
    g = setup_basic_graph(400)
    g.title = "THIS TITLE SHOULD NOT DISPLAY!!!"
    g.hide_line_markers = true
    g.hide_legend = true
    g.hide_title = true
    g.write("test/output/line_nothing_but_the_graph.png")    
  end

  def test_baseline_larger_than_data
    g = setup_basic_graph(400)
    g.title = "Baseline Larger Than Data"
    g.baseline_value = 150
    g.write("test/output/line_large_baseline.png")    
  end


  def test_hide_dots
    g = setup_basic_graph(400)
    g.title = "Hide Dots"
    g.hide_dots = true
    g.write("test/output/line_hide_dots.png")    
  end

  def test_hide_lines
    g = setup_basic_graph(400)
    g.title = "Hide Lines"
    g.hide_lines = true
    g.write("test/output/line_hide_lines.png")    
  end

  def test_wide_graph
    g = setup_basic_graph('800x400')
    g.title = "Wide Graph"
    g.write("test/output/line_wide_graph.png")    

    g = setup_basic_graph('400x200')
    g.title = "Wide Graph Small"
    g.write("test/output/line_wide_graph_small.png")
  end

  def test_negative
    g = setup_pos_neg(800)
    g.write("test/output/line_pos_neg.png")
    
    g = setup_pos_neg(400)
    g.title = 'Pos/Neg Line Test Small'
    g.write("test/output/line_pos_neg_400.png")
  end

  def test_all_negative
    g = setup_all_neg(800)
    g.write("test/output/line_all_neg.png")
    
    g = setup_all_neg(400)
    g.title = 'All Neg Line Test Small'
    g.write("test/output/line_all_neg_400.png")
  end

  def test_many_numbers    
    g = Gruff::Line.new('400x170')
    g.title = "Line Test, Many Numbers"

    data = [
      { :date => '01',
        :wpm => 0,
        :errors => 0,
        :accuracy => 0 },
      { :date => '02',
        :wpm => 10,
        :errors => 2,
        :accuracy => 80 },
      { :date => '03',
        :wpm => 15,
        :errors => 0,
        :accuracy => 100 },
      { :date => '04',
        :wpm => 16,
        :errors => 2,
        :accuracy => 87 },
      { :date => '05',
          :wpm => nil,
          :errors => nil,
          :accuracy => nil },
      { :date => '06',
        :wpm => 18,
        :errors => 1,
        :accuracy => 94 },
      { :date => '07'},
      { :date => '08' },
      { :date => '09',
         :wpm => 21,
         :errors => 1,
         :accuracy => 95 },
      { :date => '10'},
      { :date => '11'},
      { :date => '12'},
      { :date => '13'},
      { :date => '14'},
      { :date => '15'},
      { :date => '16'},
      { :date => '17'},
      { :date => '18'},
      { :date => '19',
         :wpm => 28,
         :errors => 5,
         :accuracy => 82 },
      { :date => '20'},
      { :date => '21'},
      { :date => '22'},
      { :date => '23'},
      { :date => '24'},
      { :date => '25'},
      { :date => '26'},     
      { :date => '27',
         :wpm => 37,
         :errors => 3,
         :accuracy => 92 },
    ]

    [:wpm, :errors, :accuracy].each do |field|
      g.data(field.to_s, data.collect {|d| d[field] })
    end

    labels = Hash.new
    data.each_with_index do |d, i|
      labels[i] = d[:date]
    end
    g.labels = labels

    g.write('test/output/line_many_numbers.png')
  end

  def test_no_hide_line_no_labels
    g = Gruff::Line.new
    g.title = "No Hide Line No Labels"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.hide_line_markers = false
    g.write('test/output/line_no_hide.png')
  end
  

  def test_jruby_error
    g = Gruff::Line.new
    g.theme = {
      :colors => ['#7F0099', '#2F85ED', '#2FED09','#EC962F'],
      :marker_color => '#aaa',
      :background_colors => ['#E8E8E8','#B9FD6C']
    }
    g.hide_title = true

    g.legend_font_size = 12
    g.marker_font_size = 16
    g.hide_dots = false
    g.label_max_decimals = 1

    g.write('test/output/line_jruby_error.png')
  end

private
  
  def bmi(params={})
    g = basic_graph()

    g.y_axis_label = 'BMI'

    bmis = [24.3, 23.9, 23.7, 23.7, 23.6, 23.9, 23.6, 23.7, 23.4, 23.4, 23.4, 22.9]

    g.data( 'BMI', bmis )
    g.hide_legend = true
    return g
  end

  # TODO Reset data after each theme
  def line_graph_with_themes(size=nil)
    g = Gruff::Line.new(size)
    g.title = "Multi-Line Graph Test #{size}"
    g.labels = @labels
    g.baseline_value = 90
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    # Default theme
    g.write("test/output/line_theme_keynote_#{size}.png")
  
    g = Gruff::Line.new(size)
    g.title = "Multi-Line Graph Test #{size}"
    g.labels = @labels
    g.baseline_value = 90
    g.theme_37signals
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_theme_37signals_#{size}.png")
  
    g = Gruff::Line.new(size)
    g.title = "Multi-Line Graph Test #{size}"
    g.labels = @labels
    g.baseline_value = 90
    g.theme_rails_keynote
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_theme_rails_keynote_#{size}.png")
  
    g = Gruff::Line.new(size)
    g.title = "Multi-Line Graph Test #{size}"
    g.labels = @labels
    g.baseline_value = 90
    g.theme_odeo
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("test/output/line_theme_odeo_#{size}.png")
  end

  def setup_pos_neg(size=800)
    g = Gruff::Line.new(size)
    g.title = "Pos/Neg Line Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:apples, [-1, 0, 4, -4])
    g.data(:peaches, [10, 8, 6, 3])
    return g
  end


  def setup_all_neg(size=800)
    g = Gruff::Line.new(size)
    g.title = "All Neg Line Graph Test"
    g.labels = {
      0 => '5/6', 
      1 => '5/15', 
      2 => '5/24', 
      3 => '5/30', 
    }
    g.data(:apples, [-1, -5, -20, -4])
    g.data(:peaches, [-10, -8, -6, -3])
    g
  end
  
end

require File.expand_path('../gruff_test_case', __FILE__)

class TestMiniPie < GruffTestCase
  
  def test_simple_pie
    g = setup_basic_graph(Gruff::Mini::Pie, 200)
    write_test_file g, 'mini_pie.png'
  end
  
  def test_pie_with_legend_right
    g = setup_basic_graph(Gruff::Mini::Pie, 200)
    g.legend_position = :right
    write_test_file g, 'mini_pie_right_legend.png'
  end

  # def test_code_sample    
  #   g = Gruff::Mini::Pie.new(200)
  #   g.data "Car", 200
  #   g.data "Food", 500
  #   g.data "Art", 1000
  #   g.data "Music", 16
  #   g.write "mini_pie.png"    
  # end

end

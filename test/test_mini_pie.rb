
require File.dirname(__FILE__) + "/gruff_test_case"

class TestMiniPie < GruffTestCase
  
  def test_simple_pie
    g = setup_basic_graph(Gruff::Mini::Pie, 200)
    write_test_file g, 'mini_pie.png'
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

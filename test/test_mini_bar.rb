
require File.dirname(__FILE__) + "/gruff_test_case"

class TestMiniBar < GruffTestCase
  
  def test_simple_bar
    setup_single_dataset
    g = setup_basic_graph(Gruff::Mini::Bar, 200)
    write_test_file g, 'mini_bar.png'
  end

  # def test_simple_bar_wide_dataset
  #   setup_wide_dataset
  #   g = setup_basic_graph(Gruff::Mini::Bar, 200)
  #   write_test_file g, 'mini_bar_wide_data.png'
  # end
  # 
  # def test_code_sample
  #   g = Gruff::Mini::Bar.new(200)
  #   g.data "Jim", [200, 500, 400]
  #   g.labels = { 0 => 'This Month', 1 => 'Average', 2 => 'Overall'}
  #   g.write "mini_bar_one_color.png"
  #   
  #   g = Gruff::Mini::Bar.new(200)
  #   g.data "Car", 200
  #   g.data "Food", 500
  #   g.data "Art", 1000
  #   g.data "Music", 16
  #   g.write "mini_bar_many_colors.png"
  # end

end

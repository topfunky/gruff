require File.expand_path('../gruff_test_case', __FILE__)

class TestMiniSideBar < GruffTestCase
    
  def test_one_color
    # Use a single data set
    @datasets = [
        [:Jimmy, [25, 36, 86, 39]]
      ]
    @labels = {
        0 => 'Auto', 
        1 => 'Entertainment', 
        2 => 'Food',
        3 => 'Bus'
      }

    g = setup_basic_graph(Gruff::Mini::SideBar, 200)
    write_test_file g, 'mini_side_bar.png'    
  end

  def test_multi_color
    # @datasets = [
    #     [:Jimmy, [25, 36, 86, 39]]
    #   ]
    # @labels = {
    #     0 => 'Auto', 
    #     1 => 'Entertainment', 
    #     2 => 'Food',
    #     3 => 'Bus'
    #   }

    g = setup_basic_graph(Gruff::Mini::SideBar, 200)
    write_test_file g, 'mini_side_bar_multi_color.png'    
  end

end

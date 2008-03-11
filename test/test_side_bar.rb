
require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffSideBar < GruffTestCase

  def test_bar_graph
    g = setup_basic_graph(Gruff::SideBar, 800)
    write_test_file g, 'side_bar.png'    
  end

end


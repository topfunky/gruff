
require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffSideBar < GruffTestCase

  def test_bar_graph
    g = setup_basic_graph(Gruff::SideBar, 800)
    write_test_file g, 'side_bar.png'    
  end

  def test_bar_spacing
    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 0
    g.title = "100% spacing between bars"
    g.write("test/output/side_bar_spacing_full.png")

    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 0.5
    g.title = "50% spacing between bars"
    g.write("test/output/side_bar_spacing_half.png")

    g = setup_basic_graph(Gruff::SideBar, 800)
    g.bar_spacing = 1
    g.title = "0% spacing between bars"
    g.write("test/output/side_bar_spacing_none.png")
  end

end


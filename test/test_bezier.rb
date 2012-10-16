require File.dirname(__FILE__) + "/gruff_test_case"

class TestBezier < GruffTestCase

  def setup
    @data_args = [75, 100, {
        :target => 80,
        :low => 50,
        :high => 90
    }]
  end

  def test_bezier
    g = Gruff::Bezier.new
    g.title = "Bezier?"
    g.data 'Series 1', [0, 100]
    g.write("test/output/bezier.png")
  end

  def test_bezier_2
    g = Gruff::Bezier.new
    g.data 'Series 2', [0, 127, 150]
    g.write("test/output/bezier_2.png")
  end

  def test_bezier_3
    g = Gruff::Bezier.new
    g.data 'Series 3', [100,300,200,250]
    g.minimum_value = 0
    g.write("test/output/bezier_3.png")
  end

end

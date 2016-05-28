require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffBullet < GruffTestCase

  def setup
    @data_args = [75, 100, {
        :target => 80,
        :low => 50,
        :high => 90
    }]
  end

  def test_bullet_graph
    g = Gruff::Bullet.new
    g.title = "Monthly Revenue"
    g.data(*@data_args)
    g.write("test/output/bullet_greyscale.png")
  end

  def test_no_options
    g = Gruff::Bullet.new
    g.data(*@data_args)
    g.write("test/output/bullet_no_options.png")
  end

end

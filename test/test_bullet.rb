require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffBullet < GruffTestCase

  def setup
    @data_args = [
      75,
      100,
      {
        target: 80,
        low: 50,
        high: 90
      }
    ]
  end

  def test_bullet_graph
    g = Gruff::Bullet.new
    g.title = "Monthly Revenue"
    g.data(*@data_args)
    g.replace_colors(
      %w[
        #0779e4
        #4cbbb9
        #77d8d8
        #2c003e
        #ffa372
        #ffbd69
        #85a392
        #efa8e4
        #5a3f11
        #2b580c
        #323232
        #bae5e5
      ]
    )
    g.write("test/output/bullet_greyscale.png")
  end

  def test_no_options
    g = Gruff::Bullet.new
    g.data(*@data_args)
    g.replace_colors(
      %w[
        #0779e4
        #4cbbb9
        #77d8d8
        #2c003e
        #ffa372
        #ffbd69
        #85a392
        #efa8e4
        #5a3f11
        #2b580c
        #323232
        #bae5e5
      ]
    )
    g.write("test/output/bullet_no_options.png")
  end

end

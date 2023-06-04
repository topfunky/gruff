# frozen_string_literal: true

require_relative 'gruff_test_case'

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
    g.title = 'Monthly Revenue'
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
    g.write('test/output/bullet_greyscale.png')

    assert_same_image('test/expected/bullet_greyscale.png', 'test/output/bullet_greyscale.png')
  end

  def test_target_width
    g = Gruff::Bullet.new(500)
    g.title = 'Monthly Revenue'
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
    g.write('test/output/bullet_target_width.png')

    assert_same_image('test/expected/bullet_target_width.png', 'test/output/bullet_target_width.png')
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
    g.write('test/output/bullet_no_options.png')

    assert_same_image('test/expected/bullet_no_options.png', 'test/output/bullet_no_options.png')
  end
end

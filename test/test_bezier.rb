# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestBezier < GruffTestCase
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

  def test_bezier
    g = Gruff::Bezier.new
    g.title = 'Bezier?'
    g.data 'Series 1', [0, 100]
    g.write('test/output/bezier.png')
    assert_same_image('test/expected/bezier.png', 'test/output/bezier.png')
  end

  def test_bezier_2
    g = Gruff::Bezier.new
    g.data 'Series 2', [0, 127, 150]
    g.write('test/output/bezier_2.png')
    assert_same_image('test/expected/bezier_2.png', 'test/output/bezier_2.png')
  end

  def test_bezier_3
    g = Gruff::Bezier.new
    g.data 'Series 3', [100, 300, 200, 250]
    g.minimum_value = 0
    g.write('test/output/bezier_3.png')
    assert_same_image('test/expected/bezier_3.png', 'test/output/bezier_3.png')
  end

  def test_bezier_4
    # issue 87
    g = Gruff::Bezier.new
    g.data(
      'test',
      [
        0.00233034904691358,
        0.0024406001456790108,
        0.008512412911111114,
        0.03504837642469136,
        0.3403206903185184,
        2.9516386719456804
      ]
    )
    g.write('test/output/bezier_4.png')
    assert_same_image('test/expected/bezier_4.png', 'test/output/bezier_4.png')
  end
end

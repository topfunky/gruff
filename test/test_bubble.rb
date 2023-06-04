# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestBubble < GruffTestCase
  def test_bubble
    g = Gruff::Bubble.new
    g.theme_rails_keynote
    g.title = 'Bubble Graph'
    g.data :A, [1.1, 1.5, 1.6, 1.8, 2.0, 2.2], [1.0, 1.5, 2.0, 2.5, 4.0, 4.5], [0.1, 0.1, 0.2, 0.5, 0.2, 0.1]
    g.data :B, [2.5, 3.0, 3.5, 4.0, 4.2, 4.5], [6.0, 6.2, 6.4, 6.5, 6.8, 7.0], [0.4, 0.1, 0.3, 0.2, 0.3, 0.1]
    g.data :C, [8.0, 8.5, 8.8, 9.0, 9.2, 9.8], [7.0, 7.0, 7.4, 7.8, 8.4, 9.0], [0.2, 0.3, 0.2, 0.1, 0.4, 0.2]
    g.minimum_value = 0
    g.maximum_value = 10
    g.minimum_x_value = 0
    g.maximum_x_value = 10
    g.fill_opacity = 0.6
    g.stroke_width = 2.0
    g.write('test/output/bubble.png')

    assert_same_image('test/expected/bubble.png', 'test/output/bubble.png')
  end
end

# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestRenderText < GruffTestCase
  def test_metrics
    g = Gruff::Line.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
    g.title = 'hello %S'
    g.draw

    pass
  end
end

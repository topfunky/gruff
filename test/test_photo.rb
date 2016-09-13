#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffPhotoBar < GruffTestCase

  def test_bar_graph
    run_it(800)
  end

  def test_small_bar_graph
    run_it(400)
  end

protected

  def run_it(size)
    g = Gruff::PhotoBar.new(size, 'plastik')
    g.title = "Photo Bar Graph Test #{size}px"

    g.labels = {
      0 => 'Jan.',
      1 => 'Feb.',
      2 => 'Mar.',
      3 => 'Apr.'
    }

    g.data :Jimmy, [0, 1, 3, 5], '#3c84c1'
    g.data :Charles, [8, 5, 2, -1], '#86cc3c'
    g.data :Charity, [-2, 1, 3, 7], '#c7356d'

    g.write("test/output/photo_plastik_#{size}.png")
  end

end

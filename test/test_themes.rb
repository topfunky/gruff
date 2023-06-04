# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffThemes < GruffTestCase
  def test_keynote
    g = Gruff::Bar.new
    g.theme_keynote
    g.title = 'Keynote'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_keynote.png')

    assert_same_image('test/expected/theme_keynote.png', 'test/output/theme_keynote.png')
  end

  def test_37signals
    g = Gruff::Bar.new
    g.theme_37signals
    g.title = '37signals'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_37signals.png')

    assert_same_image('test/expected/theme_37signals.png', 'test/output/theme_37signals.png')
  end

  def test_rails_keynote
    g = Gruff::Bar.new
    g.theme_rails_keynote
    g.title = 'Rails Keynote'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_rails_keynote.png')

    assert_same_image('test/expected/theme_rails_keynote.png', 'test/output/theme_rails_keynote.png')
  end

  def test_odeo
    g = Gruff::Bar.new
    g.theme_odeo
    g.title = 'Odeo'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_odeo.png')

    assert_same_image('test/expected/theme_odeo.png', 'test/output/theme_odeo.png')
  end

  def test_pastel
    g = Gruff::Bar.new
    g.theme_pastel
    g.title = 'Pastel'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_pastel.png')

    assert_same_image('test/expected/theme_pastel.png', 'test/output/theme_pastel.png')
  end

  def test_greyscale
    g = Gruff::Bar.new
    g.theme_greyscale
    g.title = 'Pastel'
    g.legend_margin = 50
    g.data(:Art, [0, 5, 8, 15])
    g.data(:Philosophy, [10, 3, 2, 8])
    g.data(:Science, [2, 15, 8, 11])

    g.write('test/output/theme_greyscale.png')

    assert_same_image('test/expected/theme_greyscale.png', 'test/output/theme_greyscale.png')
  end
end

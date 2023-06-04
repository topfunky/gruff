# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffStackedArea < GruffTestCase
  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]],
      [:Charles, [80, 54, 67, 54]],
      [:Julie, [22, 29, 35, 38]]
    ]
    @sample_labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24'
    }
  end

  def test_area_graph
    g = Gruff::StackedArea.new
    g.title = 'Visual Stacked Area Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/stacked_area_keynote.png')

    assert_same_image('test/expected/stacked_area_keynote.png', 'test/output/stacked_area_keynote.png')
  end

  def test_area_graph_small
    g = Gruff::StackedArea.new(400)
    g.title = 'Visual Stacked Area Graph Test'
    g.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/stacked_area_keynote_small.png')

    assert_same_image('test/expected/stacked_area_keynote_small.png', 'test/output/stacked_area_keynote_small.png')
  end

  def test_empty_data
    g = Gruff::StackedArea.new
    g.title = 'Contained Empty Data'
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [], '#86A697'
    g.data :Julie, nil, '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.write('test/output/stacked_area_empty_data.png')

    assert_same_image('test/expected/stacked_area_empty_data.png', 'test/output/stacked_area_empty_data.png')
  end

  def test_last_series_goes_on_bottom
    g = Gruff::StackedArea.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.last_series_goes_on_bottom = true

    g.draw
    pass
  end

  def test_duck_typing
    g = Gruff::StackedArea.new
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/stacked_area_duck_typing.png')

    assert_same_image('test/expected/stacked_area_duck_typing.png', 'test/output/stacked_area_duck_typing.png')
  end
end

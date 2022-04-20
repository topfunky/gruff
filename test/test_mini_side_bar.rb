# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestMiniSideBar < GruffTestCase
  def test_one_color
    # Use a single data set
    @datasets = [
      [:Jimmy, [25, 36, 86, 39]]
    ]
    @labels = {
      0 => 'Auto',
      1 => 'Entertainment',
      2 => 'Food',
      3 => 'Bus'
    }

    g = setup_basic_graph(Gruff::Mini::SideBar, 200)
    write_test_file(g, 'mini_side_bar.png')
    assert_same_image('test/expected/mini_side_bar.png', 'test/output/mini_side_bar.png')
  end

  def test_multi_color
    # @datasets = [
    #     [:Jimmy, [25, 36, 86, 39]]
    #   ]
    # @labels = {
    #     0 => 'Auto',
    #     1 => 'Entertainment',
    #     2 => 'Food',
    #     3 => 'Bus'
    #   }

    g = setup_basic_graph(Gruff::Mini::SideBar, 200)
    write_test_file(g, 'mini_side_bar_multi_color.png')
    assert_same_image('test/expected/mini_side_bar_multi_color.png', 'test/output/mini_side_bar_multi_color.png')
  end

  def test_duck_typing
    g = Gruff::Mini::SideBar.new(200)
    g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88], '#113285'
    g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95], '#86A697'
    g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57], '#E03C8A'
    g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100], '#72636E'
    g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88], '#86C166'
    g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32], '#60373E'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/mini_side_bar_duck_typing.png')
    assert_same_image('test/expected/mini_side_bar_duck_typing.png', 'test/output/mini_side_bar_duck_typing.png')
  end
end

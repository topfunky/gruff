# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestMiniPie < GruffTestCase
  def test_simple_pie
    g = setup_basic_graph(Gruff::Mini::Pie, 200)
    write_test_file(g, 'mini_pie.png')

    assert_same_image('test/expected/mini_pie.png', 'test/output/mini_pie.png')
  end

  def test_pie_with_legend_right
    g = setup_basic_graph(Gruff::Mini::Pie, 200)
    g.legend_position = :right
    write_test_file(g, 'mini_pie_right_legend.png')

    assert_same_image('test/expected/mini_pie_right_legend.png', 'test/output/mini_pie_right_legend.png')
  end

  def test_duck_typing
    g = Gruff::Mini::Pie.new(200)
    g.data :A, GruffCustomData.new([25]), '#113285'
    g.data :B, GruffCustomData.new([20]), '#86A697'
    g.data :C, GruffCustomData.new([55]), '#E03C8A'

    g.data :Bob, GruffCustomData.new([50, 19, 31, 89, 20, 54, 37, 65]), '#33A6B8'
    g.write('test/output/mini_pie_duck_typing.png')

    assert_same_image('test/expected/mini_pie_duck_typing.png', 'test/output/mini_pie_duck_typing.png')
  end
end

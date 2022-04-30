# frozen_string_literal: true

require_relative 'gruff_test_case'

class TestGruffSpider < GruffTestCase
  def setup
    @datasets = [
      [:Strength, [10]],
      [:Dexterity, [16]],
      [:Constitution, [12]],
      [:Intelligence, [12]],
      [:Wisdom, [10]],
      ['Charisma', [16]]
    ]
  end

  def test_spider_graph
    g = Gruff::Spider.new(20)
    g.title = 'Spider Graph Test'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/spider_keynote.png')
    assert_same_image('test/expected/spider_keynote.png', 'test/output/spider_keynote.png')
  end

  def test_pie_graph_small
    g = Gruff::Spider.new(20, 400)
    g.title = 'Visual Spider Graph Test Small'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    # Default theme
    g.write('test/output/spider_small.png')
    assert_same_image('test/expected/spider_small.png', 'test/output/spider_small.png')
  end

  def test_spider_graph_nearly_equal
    g = Gruff::Spider.new(50)
    g.title = 'Spider Graph Nearly Equal'

    g.data(:Blake, [41])
    g.data(:Aaron, [42])
    g.data(:Grouch, [40])

    g.write('test/output/spider_nearly_equal.png')
    assert_same_image('test/expected/spider_nearly_equal.png', 'test/output/spider_nearly_equal.png')
  end

  def test_pie_graph_equal
    g = Gruff::Spider.new(50)
    g.title = 'Spider Graph Equal'

    g.data(:Bert, [41])
    g.data(:Adam, [41])
    g.data(:Joe, [41])

    g.write('test/output/spider_equal.png')
    assert_same_image('test/expected/spider_equal.png', 'test/output/spider_equal.png')
  end

  def test_pie_graph_zero
    g = Gruff::Spider.new(2)
    g.title = 'Pie Graph Two One Zero'

    g.data(:Bert, [0])
    g.data(:Adam, [1])
    g.data(:Sam,  [2])

    g.write('test/output/spider_zero.png')
    assert_same_image('test/expected/spider_zero.png', 'test/output/spider_zero.png')
  end

  def test_wide
    g = setup_basic_graph('800x400')
    g.title = 'Wide spider'
    g.write('test/output/spider_wide.png')
    assert_same_image('test/expected/spider_wide.png', 'test/output/spider_wide.png')
  end

  def test_label_size
    g = setup_basic_graph
    g.title = 'Spider With Small Legend'
    g.legend_font_size = 10
    g.write('test/output/spider_legend.png')
    assert_same_image('test/expected/spider_legend.png', 'test/output/spider_legend.png')

    g = setup_basic_graph(400)
    g.title = 'Small spider With Small Legend'
    g.legend_font_size = 10
    g.write('test/output/spider_legend_small.png')
    assert_same_image('test/expected/spider_legend_small.png', 'test/output/spider_legend_small.png')
  end

  def test_theme_37signals
    g = Gruff::Spider.new(20)
    g.title = 'Spider Graph Test'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.theme = Gruff::Themes::THIRTYSEVEN_SIGNALS

    # Default theme
    g.write('test/output/spider_37signals.png')
    assert_same_image('test/expected/spider_37signals.png', 'test/output/spider_37signals.png')
  end

  def test_no_axes
    g = Gruff::Spider.new(20)
    g.title = 'Look ma, no axes'
    g.hide_axes = true
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/spider_no_axes.png')
    assert_same_image('test/expected/spider_no_axes.png', 'test/output/spider_no_axes.png')
  end

  def test_no_print
    g = Gruff::Spider.new(20)
    g.title = 'Should not print'
    g.hide_text = true
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/spider_no_print.png')
    assert_same_image('test/expected/spider_no_print.png', 'test/output/spider_no_print.png')
  end

  def test_transparency
    g = Gruff::Spider.new(20)
    g.title = 'Transparent background'
    g.hide_text = true
    g.transparent_background = true
    g.hide_axes = true
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/spider_no_background.png')
    assert_same_image('test/expected/spider_no_background.png', 'test/output/spider_no_background.png')
  end

  def test_overlay
    g = Gruff::Spider.new(20)
    g.title = 'George (blue) vs Sarah (white)'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('test/output/spider_overlay_1.png')
    assert_same_image('test/expected/spider_overlay_1.png', 'test/output/spider_overlay_1.png')

    g = Gruff::Spider.new(20)
    g.title = 'Transparent background'
    g.hide_text = true
    g.hide_axes = true
    g.transparent_background = true
    @datasets = [
      [:Strength, [18]],
      [:Dexterity, [10]],
      [:Constitution, [18]],
      [:Intelligence, [8]],
      [:Wisdom, [14]],
      ['Charisma', [4]]
    ]
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.marker_color = '#4F6EFF'
    g.write('test/output/spider_overlay_2.png')
    assert_same_image('test/expected/spider_overlay_2.png', 'test/output/spider_overlay_2.png')
  end

  def test_lots_of_data
    g = Gruff::Spider.new(10)
    @datasets = [
      [:a, [1]],
      [:b, [5]],
      [:c, [3]],
      [:d, [9]],
      [:e, [4]],
      [:f, [7]],
      [:g, [0]],
      [:h, [4]],
      [:i, [6]],
      [:j, [0]],
      [:k, [4]],
      [:l, [8]]
    ]

    @datasets.each do |data|
      g.data(data[0], data[1])
    end
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

    g.title = 'Sample Data'
    g.write('test/output/spider_lots_of_data.png')
    assert_same_image('test/expected/spider_lots_of_data.png', 'test/output/spider_lots_of_data.png')
  end

  def test_lots_of_data_with_large_names
    g = Gruff::Spider.new(10)
    @datasets = [
      [:anteaters, [1]],
      [:bulls, [5]],
      [:cats, [3]],
      [:dogs, [9]],
      [:elephants, [4]],
      [:frogs, [7]],
      [:giraffes, [0]],
      [:hamsters, [4]],
      [:iguanas, [6]],
      [:jaguar, [0]],
      [:kangaroo, [4]],
      [:locust, [8]]
    ]

    @datasets.each do |data|
      g.data(data[0], data[1])
    end
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

    g.title = 'Zoo Inventory'
    g.write('test/output/spider_lots_of_data_normal_names.png')
    assert_same_image('test/expected/spider_lots_of_data_normal_names.png', 'test/output/spider_lots_of_data_normal_names.png')
  end

  def test_rotation
    g = Gruff::Spider.new(20)
    g.title = 'Rotation'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.rotation = 45 # degrees
    g.write('test/output/spider_rotation.png')
    assert_same_image('test/expected/spider_rotation.png', 'test/output/spider_rotation.png')
  end

  def test_duck_typing
    g = Gruff::Spider.new(20)
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.data :Strength, GruffCustomData.new([18]), '#113285'
    g.data :Dexterity, GruffCustomData.new([10]), '#86A697'
    g.write('test/output/spider_duck_typing.png')
    assert_same_image('test/expected/spider_duck_typing.png', 'test/output/spider_duck_typing.png')
  end

protected

  def setup_basic_graph(size = 800, max = 20)
    g = Gruff::Spider.new(max, size)
    g.title = 'My Graph Title'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g
  end
end

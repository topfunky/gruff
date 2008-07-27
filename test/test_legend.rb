require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffLegend < GruffTestCase

  def setup
    @datasets = [
      [:Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]],
      [:Charles, [80, 54, 67, 54, 68, 70, 90, 95]],
      [:Julie, [22, 29, 35, 38, 36, 40, 46, 57]],
      [:Jane, [95, 95, 95, 90, 85, 80, 88, 100]],
      [:Philip, [90, 34, 23, 12, 78, 89, 98, 88]],
      ["Arthur", [5, 10, 13, 11, 6, 16, 22, 32]],
      ["Vincent", [5, 10, 13, 11, 6, 16, 22, 32]],
      ["Jake", [5, 10, 13, 11, 6, 16, 22, 32]],
      ["Stephen", [5, 10, 13, 11, 6, 16, 22, 32]],
      ]

    @sample_labels = {
        0 => '5/6', 
        1 => '5/15', 
        2 => '5/24', 
        3 => '5/30', 
        4 => '6/4', 
        5 => '6/12', 
        6 => '6/21', 
        7 => '6/28', 
      }      
  end

  def full_suite_for(name, type)
    [800, 400].each do |width|
      [nil, 4, 16, 30].each do |font_size|
        g = type.new(width)
        g.title = "Wrapped Legend Bar Test #{font_size}pts #{width}px"
        g.labels = @sample_labels
        0xEFD250.step(0xFF0000, 60) do |num|
          g.colors << "#%x" % num
        end
  
        @datasets.each do |data|
          g.data(data[0], data[1])
        end
  
        g.legend_font_size = font_size unless font_size.nil?
        g.write("test/output/#{name}_wrapped_legend_#{font_size}_#{width}.png")
      end
    end
  end

  def test_bar_legend_wrap
    full_suite_for(:bar, Gruff::Bar)
  end
  
  def test_pie_legend_wrap
    full_suite_for(:pie, Gruff::Pie)
  end
  
  def test_more_than_two_lines_of_legends
    @datasets = @datasets + [[:Julie2, [22, 29, 35, 38, 36, 40, 46, 57]],
                             [:Jane2, [95, 95, 95, 90, 85, 80, 88, 100]],
                             [:Philip2, [90, 34, 23, 12, 78, 89, 98, 88]],
                             ["Arthur2", [5, 10, 13, 11, 6, 16, 22, 32]],
                             ["Vincent2", [5, 10, 13, 11, 6, 16, 22, 32]],
                             ["Jake2", [5, 10, 13, 11, 6, 16, 22, 32]],
                             ["Stephen2", [5, 10, 13, 11, 6, 16, 22, 32]]]
    full_suite_for(:bar2, Gruff::Bar)
  end
end

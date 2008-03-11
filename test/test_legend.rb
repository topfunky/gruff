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

  ## TODO Fix implementation

  # def test_bar_legend_wrap
  #   [800, 400].each do |width|
  #     [nil, 4, 16, 30].each do |font_size|
  #       g = Gruff::Bar.new(width)
  #       g.title = "Wrapped Legend Bar Test #{font_size}pts #{width}px"
  #       g.labels = @sample_labels
  #       0xEFD250.step(0xFF0000, 60) do |num|
  #         g.colors << "#%x" % num
  #       end
  # 
  #       @datasets.each do |data|
  #         g.data(data[0], data[1])
  #       end
  # 
  #       g.legend_font_size = font_size unless font_size.nil?
  #       g.write("test/output/bar_wrapped_legend_#{font_size}_#{width}.png")
  #     end
  #   end
  # end
  # 
  # def test_pie_legend_wrap    
  #   [800, 400].each do |width|
  #     [nil, 4, 16, 30].each do |font_size|
  #       g = Gruff::Pie.new(width)
  #       g.title = "Wrapped Legend Pie Test #{font_size}pts #{width}px"
  #       g.labels = @sample_labels
  #       0xEFD250.step(0xFF0000, 60) do |num|
  #         g.colors << "#%x" % num
  #       end
  # 
  #       @datasets.each do |data|
  #         g.data(data[0], data[1])
  #       end
  # 
  #       g.legend_font_size = font_size unless font_size.nil?
  #       g.write("test/output/pie_wrapped_legend_#{font_size}_#{width}.png")
  #     end
  #   end
  # end
end

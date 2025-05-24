# frozen_string_literal: true

# rbs_inline: enabled

#
# Here's how to set up a Gruff::Box.
#
#   g = Gruff::Box.new
#   g.data "A", [2, 3, 5, 6, 8, 10, 11, 15, 17, 20, 28, 29, 33, 34, 45, 46, 49, 61]
#   g.data "B", [3, 4, 34, 35, 38, 39, 45, 60, 61, 69, 80, 130]
#   g.data "C", [4, 40, 41, 46, 57, 64, 77, 76, 79, 78, 99, 153]
#   g.write("box_plot.png")
#
class Gruff::Box < Gruff::Base
  # Specifies the filling opacity in area graph. Default is +0.2+.
  attr_writer :fill_opacity #: Float | Integer

  # Specifies the stroke width in line. Default is +3.0+.
  attr_writer :stroke_width #: Float | Integer

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is +0.8+.
  #
  # @rbs space_percent: Float | Integer
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' if (space_percent < 0) || (space_percent > 1)

    @spacing_factor = (1.0 - space_percent)
  end

private

  def initialize_attributes
    super
    @fill_opacity = 0.2
    @stroke_width = 3.0
    @spacing_factor = 0.8
  end

  def draw_graph
    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_top, bottom: @graph_bottom,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    width = (@graph_width - calculate_spacing) / column_count
    bar_width = width * @spacing_factor
    padding = width - bar_width

    normalized_boxes.each_with_index do |box, index|
      next if box.points.empty?

      left_x = @graph_left + (width * index) + (padding / 2.0)
      right_x = left_x + bar_width
      center_x = (left_x + right_x) / 2.0

      first_y, = conversion.get_top_bottom_scaled(box.first_quartile)
      third_y, = conversion.get_top_bottom_scaled(box.third_quartile)
      Gruff::Renderer::Rectangle.new(renderer, color: box.color, width: @stroke_width, opacity: @fill_opacity)
                                .render(left_x, first_y, right_x, third_y)

      median_y, = conversion.get_top_bottom_scaled(box.median)
      Gruff::Renderer::Line.new(renderer, color: box.color, width: @stroke_width * 2).render(left_x, median_y, right_x, median_y)

      minmax_left_x  = left_x + (bar_width / 4.0)
      minmax_right_x = right_x - (bar_width / 4.0)
      min_y, = conversion.get_top_bottom_scaled(box.lower_whisker)
      Gruff::Renderer::Line.new(renderer, color: box.color, width: @stroke_width).render(minmax_left_x, min_y, minmax_right_x, min_y)
      Gruff::Renderer::DashLine.new(renderer, color: box.color, width: @stroke_width, dasharray: [@stroke_width, @stroke_width * 2])
                               .render(center_x, min_y, center_x, first_y)

      max_y, = conversion.get_top_bottom_scaled(box.upper_whisker)
      Gruff::Renderer::Line.new(renderer, color: box.color, width: @stroke_width).render(minmax_left_x, max_y, minmax_right_x, max_y)
      Gruff::Renderer::DashLine.new(renderer, color: box.color, width: @stroke_width, dasharray: [@stroke_width, @stroke_width * 2])
                               .render(center_x, max_y, center_x, third_y)

      box.lower_outliers.each do |outlier|
        outlier_y, = conversion.get_top_bottom_scaled(outlier)
        Gruff::Renderer::Dot.new(renderer, :circle, color: box.color, opacity: @fill_opacity).render(center_x, outlier_y, @stroke_width * 2)
      end

      box.upper_outliers.each do |outlier|
        outlier_y, = conversion.get_top_bottom_scaled(outlier)
        Gruff::Renderer::Dot.new(renderer, :circle, color: box.color, opacity: @fill_opacity).render(center_x, outlier_y, @stroke_width * 2)
      end

      draw_label(center_x, index)
    end
  end

  def normalized_boxes
    @normalized_boxes ||= store.norm_data.map { |data| Gruff::Box::BoxData.new(data.label, data.points, data.color) }
  end

  # @rbs return: Integer
  def column_count
    normalized_boxes.size
  end

  # @rbs return: Integer
  def calculate_spacing
    column_count - 1
  end

  # @private
  class BoxData
    attr_accessor :label #: String
    attr_accessor :points #: Array[Float | Integer]
    attr_accessor :color #: String

    def initialize(label, points, color)
      @label = label
      @points = points.compact.sort
      @color = color
    end

    # @rbs return: Float | Integer
    def min
      points.first || 0.0
    end

    # @rbs return: Float | Integer
    def max
      points.last || 0.0
    end

    # @rbs return: Float | Integer
    def min_whisker
      [min, first_quartile - (1.5 * interquartile_range)].max
    end

    # @rbs return: Float | Integer
    def max_whisker
      [max, third_quartile + (1.5 * interquartile_range)].min
    end

    # @rbs return: Float | Integer
    def upper_whisker
      max = max_whisker
      points.select { |point| point <= max }.max
    end

    # @rbs return: Float | Integer
    def lower_whisker
      min = min_whisker
      points.select { |point| point >= min }.min
    end

    # @rbs return: Float
    def median
      if points.empty?
        0.0
      elsif points.size.odd?
        points[points.size / 2].to_f
      else
        (points[points.size / 2].to_f + points[(points.size / 2) - 1].to_f) / 2.0
      end
    end

    # @rbs return: Float
    def first_quartile
      if points.empty?
        0.0
      elsif points.size.odd?
        points[points.size / 4].to_f
      else
        (points[points.size / 4].to_f + points[(points.size / 4) - 1].to_f) / 2.0
      end
    end

    # @rbs return: Float
    def third_quartile
      if points.empty?
        0.0
      elsif points.size.odd?
        points[(points.size * 3) / 4].to_f
      else
        (points[(points.size * 3) / 4].to_f + points[((points.size * 3) / 4) - 1].to_f) / 2.0
      end
    end

    # @rbs return: Array[Float | Integer]
    def lower_outliers
      min = lower_whisker
      points.select { |point| point < min }
    end

    # @rbs return: Array[Float | Integer]
    def upper_outliers
      max = upper_whisker
      points.select { |point| point > max }
    end

    # @rbs return: Float | Integer
    def interquartile_range
      third_quartile - first_quartile
    end
  end
end

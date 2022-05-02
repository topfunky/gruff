# frozen_string_literal: true

#
# Here's how to set up a Gruff::Candlestick.
#
#   g = Gruff::Candlestick.new
#   g.data low:  79.30, high:  93.10, open:  79.44, close:  91.20
#   g.data low:  89.14, high: 106.42, open:  91.28, close: 106.26
#   g.data low: 107.89, high: 131.00, open: 108.20, close: 129.04
#   g.data low: 103.10, high: 137.98, open: 132.76, close: 115.81
#   g.write("candlestick.png")
#
class Gruff::Candlestick < Gruff::Base
  # Allow for vertical marker lines.
  attr_writer :show_vertical_markers

  # Specifies the filling opacity in area graph. Default is +0.4+.
  attr_writer :fill_opacity

  # Specifies the stroke width in line. Default is +2.0+.
  attr_writer :stroke_width

  # Specifies the color with up bar. Default is +'#579773'+.
  attr_writer :up_color

  # Specifies the color with down bar. Default is +'#eb5242'+.
  attr_writer :down_color

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is +0.8+.
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' unless (space_percent >= 0) && (space_percent <= 1)

    @spacing_factor = (1 - space_percent)
  end

  def data(low:, high:, open:, close:)
    super('', [low, high, open, close])
  end

private

  def initialize_attributes
    super
    @show_vertical_markers = false
    @fill_opacity = 0.4
    @spacing_factor = 0.9
    @stroke_width = 2.0
    @up_color = '#579773'
    @down_color = '#eb5242'

    @sort = false
    @hide_legend = true
  end

  def draw_graph
    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new(
      top: @graph_top, bottom: @graph_bottom,
      minimum_value: minimum_value, maximum_value: maximum_value, spread: @spread
    )

    width = (@graph_width - calculate_spacing) / normalized_candlesticks.size
    bar_width = width * @spacing_factor
    padding = width - bar_width

    normalized_candlesticks.each_with_index do |candlestick, index|
      left_x = @graph_left + (width * index) + (padding / 2)
      right_x = left_x + bar_width
      center_x = (left_x + right_x) / 2
      color = candlestick.close >= candlestick.open ? @up_color : @down_color

      draw_label(center_x, index) do
        break if @hide_line_markers
        break unless @show_vertical_markers

        Gruff::Renderer::Line.new(renderer, color: @marker_color).render(center_x, @graph_bottom, center_x, @graph_top)
        if @marker_shadow_color
          Gruff::Renderer::Line.new(renderer, color: @marker_shadow_color)
                               .render(center_x + 1, @graph_bottom, center_x + 1, @graph_top)
        end
      end

      open_y, = conversion.get_top_bottom_scaled(candlestick.open)
      close_y, = conversion.get_top_bottom_scaled(candlestick.close)
      Gruff::Renderer::Rectangle.new(renderer, color: color, opacity: @fill_opacity, width: @stroke_width).render(left_x, open_y, right_x, close_y)

      low_y, = conversion.get_top_bottom_scaled(candlestick.low)
      y = open_y < close_y ? close_y : open_y
      Gruff::Renderer::Line.new(renderer, color: color, width: @stroke_width).render(center_x, low_y, center_x, y)
      high_y, = conversion.get_top_bottom_scaled(candlestick.high)
      y = open_y > close_y ? close_y : open_y
      Gruff::Renderer::Line.new(renderer, color: color, width: @stroke_width).render(center_x, y, center_x, high_y)
    end
  end

  def normalized_candlesticks
    @candlesticks ||= store.norm_data.map { |data| Gruff::Candlestick::CandlestickData.new(*data.points) }
  end

  def calculate_spacing
    @scale * (column_count - 1)
  end

  # @private
  class CandlestickData < Struct.new(:low, :high, :open, :close)
  end
end

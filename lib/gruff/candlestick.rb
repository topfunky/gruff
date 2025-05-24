# frozen_string_literal: true

# rbs_inline: enabled

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
  attr_writer :show_vertical_markers #: bool

  # Specifies the filling opacity in area graph. Default is +0.4+.
  attr_writer :fill_opacity #: Float | Integer

  # Specifies the stroke width in line. Default is +2.0+.
  attr_writer :stroke_width #: Float | Integer

  # Specifies the color with up bar. Default is +'#579773'+.
  attr_writer :up_color #: String

  # Specifies the color with down bar. Default is +'#eb5242'+.
  attr_writer :down_color #: String

  # Can be used to adjust the spaces between the bars.
  # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
  # and 1 means that each bars' width is nearly 0 (so each bar is a simple
  # line with no x dimension).
  #
  # Default value is +0.9+.
  #
  # @rbs space_percent: Float | Integer
  def spacing_factor=(space_percent)
    raise ArgumentError, 'spacing_factor must be between 0.00 and 1.00' if (space_percent < 0) || (space_percent > 1)

    @spacing_factor = (1.0 - space_percent)
  end

  # The sort feature is not supported in this graph.
  def sort=(_value)
    raise 'Not support #sort= in Gruff::Candlestick'
  end

  # The sort feature is not supported in this graph.
  def sorted_drawing=(_value)
    raise 'Not support #sorted_drawing= in Gruff::Candlestick'
  end

  # @rbs low: Float | Integer
  # @rbs high: Float | Integer
  # @rbs open: Float | Integer
  # @rbs close: Float | Integer
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

    @hide_legend = true
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

    normalized_candlesticks.each_with_index do |candlestick, index|
      left_x = @graph_left + (width * index) + (padding / 2.0)
      right_x = left_x + bar_width
      center_x = (left_x + right_x) / 2.0
      color = candlestick.close >= candlestick.open ? @up_color : @down_color

      draw_label(center_x, index) { draw_marker_vertical_line(center_x) if show_marker_vertical_line? }

      open_y, = conversion.get_top_bottom_scaled(candlestick.open)
      close_y, = conversion.get_top_bottom_scaled(candlestick.close)
      Gruff::Renderer::Rectangle.new(renderer, color: color, opacity: @fill_opacity, width: @stroke_width).render(left_x, open_y, right_x, close_y)

      low_y, = conversion.get_top_bottom_scaled(candlestick.low)
      y = [open_y, close_y].max
      Gruff::Renderer::Line.new(renderer, color: color, width: @stroke_width).render(center_x, low_y, center_x, y)
      high_y, = conversion.get_top_bottom_scaled(candlestick.high)
      y = [open_y, close_y].min
      Gruff::Renderer::Line.new(renderer, color: color, width: @stroke_width).render(center_x, y, center_x, high_y)
    end
  end

  def normalized_candlesticks
    @normalized_candlesticks ||= store.norm_data.map { |data| Gruff::Candlestick::CandlestickData.new(*data.points) } # steep:ignore
  end

  # @rbs return: Integer
  def column_count
    normalized_candlesticks.size
  end

  # @rbs return: Integer
  def calculate_spacing
    column_count - 1
  end

  # @rbs return: bool
  def show_marker_vertical_line?
    !@hide_line_markers && @show_vertical_markers
  end

  # @private
  class CandlestickData
    attr_accessor :low
    attr_accessor :high
    attr_accessor :open
    attr_accessor :close

    def initialize(low, high, open, close)
      @low = low.to_f
      @high = high.to_f
      @open = open.to_f
      @close = close.to_f
    end
  end
end

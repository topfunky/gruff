# frozen_string_literal: true

# rbs_inline: enabled

#
# A bullet graph is a variation of a bar graph.
# http://en.wikipedia.org/wiki/Bullet_graph
#
# Here's how to set up a Gruff::Bullet.
#
#   g = Gruff::Bullet.new
#   g.title = 'Monthly Revenue'
#   g.data 75, 100, { target: 80, low: 50, high: 90 }
#   g.write('bullet.png')
#
class Gruff::Bullet < Gruff::Base
  # @rbs target_width: String | Float | Integer
  # @rbs return: void
  def initialize(target_width = '400x40')
    super

    if target_width.is_a?(String)
      @columns, @rows = target_width.split('x').map(&:to_f)
    else
      @columns = target_width.to_f
      @rows = target_width.to_f / 5.0
    end
    @columns.freeze
    @rows.freeze

    self.theme = Gruff::Themes::GREYSCALE
  end

  def initialize_attributes
    super

    @title_font.size = 20
    @title_font.bold = false
  end
  private :initialize_attributes

  # @rbs value: Float | Integer
  # @rbs maximum_value: Float | Integer
  # @rbs options: Hash[Symbol, Float | Integer]
  def data(value, maximum_value, options = {})
    @value = value.to_f
    self.maximum_value = maximum_value.to_f
    @options = options
    @options.map { |k, v| @options[k] = v.to_f if v.respond_to?(:to_f) }
  end

  def draw
    # TODO: Left label
    # TODO Bottom labels and markers
    # @graph_bottom
    # Calculations are off 800x???

    @colors.reverse!

    draw_title

    title_width  = calculate_width(@title_font, @title)
    margin       = 30.0
    thickness    = @raw_rows / 6.0
    right_margin = margin
    graph_left   = [title_width * 1.3, margin].max
    graph_width  = @raw_columns - graph_left - right_margin
    graph_height = thickness * 3.0

    # Background
    rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: @colors[0])
    rect_renderer.render(graph_left, 0, graph_left + graph_width, graph_height)

    %i[high low].each_with_index do |indicator, index|
      next unless @options.key?(indicator)

      indicator_width_x = graph_left + (graph_width * (@options[indicator] / maximum_value))

      rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: @colors[index + 1])
      rect_renderer.render(graph_left, 0, indicator_width_x, graph_height)
    end

    if @options.key?(:target)
      target_x = graph_left + (graph_width * (@options[:target] / maximum_value))
      half_thickness = thickness / 2.0

      rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: @marker_color)
      rect_renderer.render(target_x, half_thickness, target_x + half_thickness, (thickness * 2) + half_thickness)
    end

    # Value
    rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: @marker_color)
    rect_renderer.render(graph_left, thickness, graph_left + (graph_width * (@value / maximum_value)), thickness * 2)
  end

private

  def draw_title
    return if hide_title?

    font_height = calculate_caps_height(@title_font)

    text_renderer = Gruff::Renderer::Text.new(renderer, @title, font: @title_font)
    text_renderer.add_to_render_queue(1.0, 1.0, font_height / 2.0, font_height / 2.0, Magick::NorthWestGravity)
  end
end

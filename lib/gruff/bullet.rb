# frozen_string_literal: true

require 'gruff/base'
require 'gruff/themes'

# http://en.wikipedia.org/wiki/Bullet_graph
class Gruff::Bullet < Gruff::Base
  def initialize(target_width = '400x40')
    if target_width.is_a?(String)
      geometric_width, geometric_height = target_width.split('x')
      @columns = geometric_width.to_f
      @rows = geometric_height.to_f
    else
      @columns = target_width.to_f
      @rows = target_width.to_f / 5.0
    end
    @columns.freeze
    @rows.freeze

    initialize_ivars

    reset_themes
    self.theme = Gruff::Themes::GREYSCALE
    @title_font_size = 20
  end

  def data(value, maximum_value, options = {})
    @value = value.to_f
    self.maximum_value = maximum_value.to_f
    @options = options
    @options.map { |k, v| @options[k] = v.to_f if v.is_a?(Numeric) }
  end

  def draw
    # TODO: Left label
    # TODO Bottom labels and markers
    # @graph_bottom
    # Calculations are off 800x???

    @colors.reverse!

    draw_title

    title_width  = calculate_width(@title_font_size, @title)
    margin       = 30.0
    thickness    = @raw_rows / 6.0
    right_margin = margin
    graph_left   = (@title && (title_width * 1.3)) || margin
    graph_width  = @raw_columns - graph_left - right_margin
    graph_height = thickness * 3.0

    # Background
    rect_renderer = Gruff::Renderer::Rectangle.new(color: @colors[0])
    rect_renderer.render(graph_left, 0, graph_left + graph_width, graph_height)

    [:high, :low].each_with_index do |indicator, index|
      next unless @options.key?(indicator)

      indicator_width_x = graph_left + graph_width * (@options[indicator] / maximum_value)

      rect_renderer = Gruff::Renderer::Rectangle.new(color: @colors[index + 1])
      rect_renderer.render(graph_left, 0, indicator_width_x, graph_height)
    end

    if @options.key?(:target)
      target_x = graph_left + graph_width * (@options[:target] / maximum_value)
      half_thickness = thickness / 2.0

      rect_renderer = Gruff::Renderer::Rectangle.new(color: @font_color)
      rect_renderer.render(target_x, half_thickness, target_x + half_thickness, thickness * 2 + half_thickness)
    end

    # Value
    rect_renderer = Gruff::Renderer::Rectangle.new(color: @font_color)
    rect_renderer.render(graph_left, thickness, graph_left + graph_width * (@value / maximum_value), thickness * 2)

    Gruff::Renderer.finish
  end

  def draw_title
    return unless @title

    font_height = calculate_caps_height(scale_fontsize(@title_font_size))

    text_renderer = Gruff::Renderer::Text.new(@title, font: @font, size: @title_font_size, color: @font_color)
    text_renderer.render(1.0, 1.0, font_height / 2, font_height / 2, Magick::NorthWestGravity)
  end
end

require File.dirname(__FILE__) + '/base'

class Gruff::Bullet < Gruff::Base

  def initialize(target_width="400x40")
    if not Numeric === target_width
      geometric_width, geometric_height = target_width.split('x')
      @columns = geometric_width.to_f
      @rows = geometric_height.to_f
    else
      @columns = target_width.to_f
      @rows = target_width.to_f / 5.0
    end

    initialize_ivars

    reset_themes
    theme_greyscale
    @title_font_size = 20
  end

  def data(value, maximum_value, options={})
    @value = value.to_f
    @maximum_value = maximum_value.to_f
    @options = options
    @options.map { |k, v| @options[k] = v.to_f if v === Numeric }
  end

  # def setup_drawing
  #   # Maybe should be done in one of the following functions for more granularity.
  #   unless @has_data
  #     draw_no_data()
  #     return
  #   end
  #
  #   normalize()
  #   setup_graph_measurements()
  #   sort_norm_data() if @sort # Sort norm_data with avg largest values set first (for display)
  #
  #   draw_legend()
  #   draw_line_markers()
  #   draw_axis_labels()
  #   draw_title
  # end

  def draw
    # TODO Left label
    # TODO Bottom labels and markers
    # @graph_bottom
    # Calculations are off 800x???

    @colors.reverse!

    draw_title

    @margin       = 30.0
    @thickness    = @raw_rows / 6.0
    @right_margin = @margin
    @graph_left   = @title_width * 1.3 rescue @margin # HACK Need to calculate real width
    @graph_width  = @raw_columns - @graph_left - @right_margin
    @graph_height = @thickness * 3.0

    # Background
    @d = @d.fill @colors[0]
    @d = @d.rectangle(@graph_left, 0, @graph_left + @graph_width, @graph_height)

    [:high, :low].each_with_index do |indicator, index|
      next unless @options.has_key?(indicator)
      @d = @d.fill @colors[index + 1]
      indicator_width_x  = @graph_left + @graph_width * (@options[indicator] / @maximum_value)
      @d = @d.rectangle(@graph_left, 0, indicator_width_x, @graph_height)
    end

    if @options.has_key?(:target)
      @d = @d.fill @font_color
      target_x = @graph_left + @graph_width * (@options[:target] / @maximum_value)
      half_thickness = @thickness / 2.0
      @d = @d.rectangle(target_x, half_thickness, target_x + half_thickness, @thickness * 2 + half_thickness)
    end

    # Value
    @d = @d.fill @font_color
    @d = @d.rectangle(@graph_left, @thickness, @graph_left + @graph_width * (@value / @maximum_value), @thickness * 2)

    @d.draw(@base_image)
  end

  def draw_title
    return unless @title

    @font_height = calculate_caps_height(scale_fontsize(@title_font_size))
    @title_width = calculate_width(@title_font_size, @title)

    @d.fill        = @font_color
    @d.font        = @font if @font
    @d.stroke('transparent')
    @d.font_weight = NormalWeight
    @d.pointsize   = scale_fontsize(@title_font_size)
    @d.gravity     = NorthWestGravity
    @d             = @d.annotate_scaled(*[
      @base_image,
      1.0, 1.0,
      @font_height/2, @font_height/2,
      @title,
      @scale
    ])
  end

end

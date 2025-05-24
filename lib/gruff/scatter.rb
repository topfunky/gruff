# frozen_string_literal: true

# rbs_inline: enabled

#
# Here's how to set up a Gruff::Scatter.
#
#   g = Gruff::Scatter.new(800)
#   g.data :apples, [1,2,3,4], [4,3,2,1]
#   g.data 'oranges', [5,7,8], [4,1,7]
#   g.write('scatter.png')
#
class Gruff::Scatter < Gruff::Base
  # Maximum X Value. The value will get overwritten by the max in the
  # datasets.
  attr_writer :maximum_x_value #: Float | Integer

  # Minimum X Value. The value will get overwritten by the min in the
  # datasets.
  attr_writer :minimum_x_value #: Float | Integer

  # The number of vertical lines shown for reference.
  attr_writer :marker_x_count #: Integer

  # Attributes to allow customising the size of the points.
  attr_writer :circle_radius #: Float | Integer
  attr_writer :stroke_width #: Float | Integer

  # Allow for vertical marker lines.
  attr_writer :show_vertical_markers #: bool

  # Allow enabling vertical lines. When you have a lot of data, they can work great.
  # @deprecated Please use {#show_vertical_markers=} instead.
  def enable_vertical_line_markers=(value)
    warn '#enable_vertical_line_markers= is deprecated. Please use `show_vertical_markers` attribute instead'
    @show_vertical_markers = value
  end

  # Allow using vertical labels in the X axis.
  # @deprecated Please use {Gruff::Base#label_rotation=} instead.
  def use_vertical_x_labels=(_value)
    warn '#use_vertical_x_labels= is deprecated. It is no longer effective. Please use `#label_rotation=` instead'
  end

  # Allow using vertical labels in the X axis (and setting the label margin).
  # @deprecated
  def x_label_margin=(_value)
    warn '#x_label_margin= is deprecated. It is no longer effective.'
  end

  # Allow disabling the significant rounding when labeling the X axis.
  # This is useful when working with a small range of high values (for example, a date range of months, while seconds as units).
  # @deprecated
  def disable_significant_rounding_x_axis=(_value)
    warn '#disable_significant_rounding_x_axis= is deprecated. It is no longer effective.'
  end

  # The first parameter is the name of the dataset.  The next two are the
  # x and y axis data points contain in their own array in that respective
  # order.  The final parameter is the color.
  #
  # Can be called multiple times with different datasets for a multi-valued
  # graph.
  #
  # If the color argument is nil, the next color from the default theme will
  # be used.
  #
  # @note If you want to use a preset theme, you must set it before calling {#data}.
  #
  # @param name [String, Symbol] containing the name of the dataset.
  # @param x_data_points [Array] An Array of x-axis data points.
  # @param y_data_points [Array] An Array of y-axis data points.
  # @param color [String] The hex string for the color of the dataset. Defaults to nil.
  #
  # @raise [ArgumentError] Data points contain nil values.
  #   This error will get raised if either the x or y axis data points array
  #   contains a +nil+ value.  The graph will not make an assumption
  #   as how to graph +nil+.
  # @raise [ArgumentError] +x_data_points+ is empty.
  #   This error is raised when the array for the x-axis points are empty
  # @raise [ArgumentError] +y_data_points+ is empty.
  #   This error is raised when the array for the y-axis points are empty.
  # @raise [ArgumentError] +x_data_points.length != y_data_points.length+.
  #   Error means that the x and y axis point arrays do not match in length.
  #
  # @example
  #   g = Gruff::Scatter.new
  #   g.data(:apples, [1,2,3], [3,2,1])
  #   g.data('oranges', [1,1,1], [2,3,4])
  #   g.data('bitter_melon', [3,5,6], [6,7,8], '#000000')
  #
  # @rbs name: String | Symbol
  # @rbs x_data_points: Array[nil | Float | Integer] | nil
  # @rbs y_data_points: Array[nil | Float | Integer] | nil
  # @rbs color: String
  def data(name, x_data_points = [], y_data_points = [], color = nil)
    # make sure it's an array
    x_data_points = Array(x_data_points)
    y_data_points = Array(y_data_points)

    raise ArgumentError, 'Data Points contain nil Value!' if x_data_points.include?(nil) || y_data_points.include?(nil)
    raise ArgumentError, 'x_data_points is empty!' if x_data_points.empty?
    raise ArgumentError, 'y_data_points is empty!' if y_data_points.empty?
    raise ArgumentError, 'x_data_points.length != y_data_points.length!' if x_data_points.length != y_data_points.length

    # Call the existing data routine for the x/y axis data
    store.add(name, x_data_points, y_data_points, color)
  end

  alias dataxy data

private

  def initialize_store
    @store = Gruff::Store.new(Gruff::Store::XYData)
  end

  def initialize_attributes
    super

    @circle_radius = nil
    @show_vertical_markers = false
    @marker_x_count = nil
    @maximum_x_value = @minimum_x_value = nil
    @stroke_width = nil
  end

  def setup_drawing
    @center_labels_over_point = false
    super
  end

  def setup_data
    # TODO: Need to get x-axis labels working. Current behavior will be to not allow.
    @labels = {}

    # Update the global min/max values for the x data
    @maximum_x_value = (@maximum_x_value || store.max_x).to_f
    @minimum_x_value = (@minimum_x_value || store.min_x).to_f

    if @x_axis_increment
      # TODO: Make this work for negative values
      @maximum_x_value = [@maximum_x_value.ceil, @x_axis_increment.to_f].max
      @minimum_x_value = @minimum_x_value.floor
    end

    super
  end

  def draw_graph
    stroke_width  = @stroke_width  || clip_value_if_greater_than(@columns / (store.norm_data.first.x_points.size * 4.0), 5.0)
    circle_radius = @circle_radius || clip_value_if_greater_than(@columns / (store.norm_data.first.x_points.size * 2.5), 5.0)

    store.norm_data.each do |data_row|
      data_row.coordinates.each do |x_value, y_value|
        next if y_value.nil? || x_value.nil?

        new_x = @graph_left + (x_value * @graph_width)
        new_y = @graph_bottom - (y_value * @graph_height)

        Gruff::Renderer::Circle.new(renderer, color: data_row.color, width: stroke_width).render(new_x, new_y, new_x - circle_radius, new_y)
      end
    end
  end

  def calculate_spread
    super
    @x_spread = @maximum_x_value.to_f - @minimum_x_value.to_f
    @x_spread = @x_spread > 0 ? @x_spread : 1.0
  end

  def normalize
    return unless data_given?

    store.normalize(minimum_x: @minimum_x_value, spread_x: @x_spread, minimum_y: minimum_value, spread_y: @spread)
  end

  def draw_line_markers
    # do all of the stuff for the horizontal lines on the y-axis
    super
    return if @hide_line_markers

    increment_x_scaled = (@graph_width / (@x_spread / x_increment)).to_f

    # Draw vertical line markers and annotate with numbers
    (0..marker_x_count).each do |index|
      # TODO: Fix the vertical lines, and enable them by default. Not pretty when they don't match up with top y-axis line
      if @show_vertical_markers
        draw_marker_vertical_line(@graph_left + (index * increment_x_scaled))
      end

      unless @hide_line_numbers
        marker_label = (BigDecimal(index.to_s) * BigDecimal(x_increment.to_s)) + BigDecimal(@minimum_x_value.to_s)
        label = x_axis_label(marker_label, x_increment)
        x = @graph_left + (increment_x_scaled * index)
        y = @graph_bottom
        x_offset, y_offset = calculate_label_offset(@marker_font, label, @label_margin, @label_rotation)

        draw_label_at(1.0, 1.0, x + x_offset, y + y_offset, label, rotation: @label_rotation)
      end
    end
  end

  # @rbs return: Integer
  def marker_x_count
    # TODO: Do the same for larger numbers...100, 75, 50, 25
    @marker_x_count ||= begin
      if @x_axis_increment.nil?
        count = nil
        (3..7).each do |lines|
          if @x_spread % lines == 0.0
            count = lines and break
          end
        end
        count || 4
      else
        (@x_spread / @x_axis_increment).to_i
      end
    end
  end

  # @rbs return: Float | Integer | BigDecimal
  def x_increment
    @x_increment ||= begin
      if @x_axis_increment.nil?
        @x_spread > 0 ? significant(@x_spread / marker_x_count) : 1.0
      else
        @x_axis_increment.to_f
      end
    end
  end
end

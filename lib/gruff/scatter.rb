# frozen_string_literal: true

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
  attr_writer :maximum_x_value

  # Minimum X Value. The value will get overwritten by the min in the
  # datasets.
  attr_writer :minimum_x_value

  # The number of vertical lines shown for reference.
  attr_writer :marker_x_count

  # Attributes to allow customising the size of the points.
  attr_writer :circle_radius
  attr_writer :stroke_width

  # Allow disabling the significant rounding when labeling the X axis.
  # This is useful when working with a small range of high values (for example, a date range of months, while seconds as units).
  attr_writer :disable_significant_rounding_x_axis

  # Allow enabling vertical lines. When you have a lot of data, they can work great.
  attr_writer :enable_vertical_line_markers

  # Allow using vertical labels in the X axis (and setting the label margin).
  attr_writer :x_label_margin
  attr_writer :use_vertical_x_labels

  # Allow passing lambdas to format labels.
  attr_writer :y_axis_label_format
  attr_writer :x_axis_label_format

  def initialize_store
    @store = Gruff::Store.new(Gruff::Store::XYData)
  end
  private :initialize_store

  def initialize_ivars
    super

    @baseline_x_color = @baseline_y_color = 'red'
    @baseline_x_value = @baseline_y_value = nil
    @circle_radius = nil
    @disable_significant_rounding_x_axis = false
    @enable_vertical_line_markers = false
    @marker_x_count = nil
    @maximum_x_value = @minimum_x_value = nil
    @stroke_width = nil
    @use_vertical_x_labels = false
    @x_axis_label_format = nil
    @x_label_margin = nil
    @y_axis_label_format = nil
  end
  private :initialize_ivars

  def draw
    super
    return unless data_given?

    # Check to see if more than one datapoint was given. NaN can result otherwise.
    @x_increment = (@x_spread > 1) ? (@graph_width / (@x_spread - 1).to_f) : @graph_width

    store.norm_data.each do |data_row|
      data_row.coordinates.each do |x_value, y_value|
        next if y_value.nil? || x_value.nil?

        new_x = get_x_coord(x_value, @graph_width, @graph_left)
        new_y = @graph_top + (@graph_height - y_value * @graph_height)

        # Reset each time to avoid thin-line errors
        stroke_width  = @stroke_width  || clip_value_if_greater_than(@columns / (store.norm_data.first[1].size * 4), 5.0)
        circle_radius = @circle_radius || clip_value_if_greater_than(@columns / (store.norm_data.first[1].size * 2.5), 5.0)
        Gruff::Renderer::Circle.new(color: data_row.color, width: stroke_width).render(new_x, new_y, new_x - circle_radius, new_y)
      end
    end
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
  # @param x_data_points [Array] An Array of of x-axis data points.
  # @param y_data_points [Array] An Array of of y-axis data points.
  # @param color [String] The hex string for the color of the dataset. Defaults to nil.
  #
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
  def data(name, x_data_points = [], y_data_points = [], color = nil)
    # make sure it's an array
    x_data_points = Array(x_data_points)
    y_data_points = Array(y_data_points)

    raise ArgumentError, 'Data Points contain nil Value!' if x_data_points.include?(nil) || y_data_points.include?(nil)
    raise ArgumentError, 'x_data_points is empty!' if x_data_points.empty?
    raise ArgumentError, 'y_data_points is empty!' if y_data_points.empty?
    raise ArgumentError, 'x_data_points.length != y_data_points.length!' if x_data_points.length != y_data_points.length

    # Call the existing data routine for the x/y axis data
    store.add(name, y_data_points, color, x_data_points)
  end

  alias dataxy data

private

  def setup_data
    # Update the global min/max values for the x data
    @maximum_x_value ||= store.max_x
    @minimum_x_value ||= store.min_x

    super
  end

  def setup_drawing
    # TODO: Need to get x-axis labels working. Current behavior will be to not allow.
    @labels = {}

    super
  end

  def calculate_spread #:nodoc:
    super
    @x_spread = @maximum_x_value.to_f - @minimum_x_value.to_f
    @x_spread = @x_spread > 0 ? @x_spread : 1
  end

  def normalize
    return unless data_given?

    store.normalize(minimum_x: @minimum_x_value, spread_x: @x_spread, minimum_y: minimum_value, spread_y: @spread)
  end

  def draw_line_markers
    # do all of the stuff for the horizontal lines on the y-axis
    super
    return if @hide_line_markers

    if @x_axis_increment.nil?
      # TODO: Do the same for larger numbers...100, 75, 50, 25
      if @marker_x_count.nil?
        (3..7).each do |lines|
          if @x_spread % lines == 0.0
            @marker_x_count = lines
            break
          end
        end
        @marker_x_count ||= 4
      end
      @x_increment = (@x_spread > 0) ? (@x_spread / @marker_x_count) : 1
      unless @disable_significant_rounding_x_axis
        @x_increment = significant(@x_increment)
      end
    else
      # TODO: Make this work for negative values
      @maximum_x_value = [maximum_value.ceil, @x_axis_increment].max
      @minimum_x_value = @minimum_x_value.floor
      calculate_spread
      normalize

      self.marker_count = (@x_spread / @x_axis_increment).to_i
      @x_increment = @x_axis_increment
    end
    increment_x_scaled = @graph_width.to_f / (@x_spread / @x_increment)

    # Draw vertical line markers and annotate with numbers
    (0..@marker_x_count).each do |index|
      # TODO: Fix the vertical lines, and enable them by default. Not pretty when they don't match up with top y-axis line
      if @enable_vertical_line_markers
        x = @graph_left + @graph_width - index.to_f * increment_x_scaled

        line_renderer = Gruff::Renderer::Line.new(color: @marker_color, shadow_color: @marker_shadow_color)
        line_renderer.render(x, @graph_top, x, @graph_bottom)
      end

      unless @hide_line_numbers
        marker_label = index * @x_increment + @minimum_x_value.to_f
        y_offset = @graph_bottom + (@x_label_margin || LABEL_MARGIN)
        x_offset = get_x_coord(index.to_f, increment_x_scaled, @graph_left)

        label = vertical_label(marker_label, @x_increment)
        rotation = -90.0 if @use_vertical_x_labels
        text_renderer = Gruff::Renderer::Text.new(label, font: @font, size: @marker_font_size, color: @font_color, rotation: rotation)
        text_renderer.add_to_render_queue(1.0, 1.0, x_offset, y_offset)
      end
    end
  end

  def label(value, increment)
    if @y_axis_label_format
      @y_axis_label_format.call(value)
    else
      super
    end
  end

  def vertical_label(value, increment)
    if @x_axis_label_format
      @x_axis_label_format.call(value)
    else
      label(value, increment)
    end
  end

  def get_x_coord(x_data_point, width, offset) #:nodoc:
    x_data_point * width + offset
  end
end

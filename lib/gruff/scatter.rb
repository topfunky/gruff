# frozen_string_literal: true

require 'gruff/base'

# Here's how to set up an XY Scatter Chart
#
# g = Gruff::Scatter.new(800)
# g.data(:apples, [1,2,3,4], [4,3,2,1])
# g.data('oranges', [5,7,8], [4,1,7])
# g.write('test/output/scatter.png')
#
#
class Gruff::Scatter < Gruff::Base
  # Maximum X Value. The value will get overwritten by the max in the
  # datasets.
  attr_accessor :maximum_x_value

  # Minimum X Value. The value will get overwritten by the min in the
  # datasets.
  attr_accessor :minimum_x_value

  # The number of vertical lines shown for reference
  attr_accessor :marker_x_count

  #~ # Draw a dashed horizontal line at the given y value
  #~ attr_accessor :baseline_y_value

  #~ # Color of the horizontal baseline
  #~ attr_accessor :baseline_y_color

  #~ # Draw a dashed horizontal line at the given y value
  #~ attr_accessor :baseline_x_value

  #~ # Color of the horizontal baseline
  #~ attr_accessor :baseline_x_color

  # Attributes to allow customising the size of the points
  attr_accessor :circle_radius
  attr_accessor :stroke_width

  # Allow disabling the significant rounding when labeling the X axis
  # This is useful when working with a small range of high values (for example, a date range of months, while seconds as units)
  attr_accessor :disable_significant_rounding_x_axis

  # Allow enabling vertical lines. When you have a lot of data, they can work great
  attr_accessor :enable_vertical_line_markers

  # Allow using vertical labels in the X axis (and setting the label margin)
  attr_accessor :x_label_margin
  attr_accessor :use_vertical_x_labels

  # Allow passing lambdas to format labels
  attr_accessor :y_axis_label_format
  attr_accessor :x_axis_label_format

  # Gruff::Scatter takes the same parameters as the Gruff::Line graph
  #
  # ==== Example
  #
  # g = Gruff::Scatter.new
  #
  def initialize(*)
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

    @store = Gruff::Store.new(Gruff::Store::XYData)
  end

  def setup_drawing
    # TODO: Need to get x-axis labels working. Current behavior will be to not allow.
    @labels = {}

    super
  end

  def draw
    super
    return unless data_given?

    # Check to see if more than one datapoint was given. NaN can result otherwise.
    @x_increment = (@x_spread > 1) ? (@graph_width / (@x_spread - 1).to_f) : @graph_width

    #~ if (defined?(@norm_y_baseline)) then
      #~ level = @graph_top + (@graph_height - @norm_baseline * @graph_height)
      #~ @d.push
      #~ @d.stroke_color @baseline_color
      #~ @d.fill_opacity 0.0
      #~ @d.stroke_dasharray(10, 20)
      #~ @d.stroke_width 5
      #~ @d.line(@graph_left, level, @graph_left + @graph_width, level)
      #~ @d.pop
    #~ end

    #~ if (defined?(@norm_x_baseline)) then

    #~ end

    store.norm_data.each do |data_row|
      data_row.y_points.each_with_index do |data_point, index|
        x_value = data_row.x_points[index]
        next if data_point.nil? || x_value.nil?

        new_x = get_x_coord(x_value, @graph_width, @graph_left)
        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        # Reset each time to avoid thin-line errors
        stroke_width  = @stroke_width || clip_value_if_greater_than(@columns / (store.norm_data.first[1].size * 4), 5.0)
        circle_radius = @circle_radius || clip_value_if_greater_than(@columns / (store.norm_data.first[1].size * 2.5), 5.0)
        Gruff::Renderer::Circle.new(color: data_row.color, width: stroke_width).render(new_x, new_y, new_x - circle_radius, new_y)
      end
    end

    @d.draw(@base_image)
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
  # NOTE: If you want to use a preset theme, you must set it before calling
  # data().
  #
  # ==== Parameters
  # name:: String or Symbol containing the name of the dataset.
  # x_data_points:: An Array of of x-axis data points.
  # y_data_points:: An Array of of y-axis data points.
  # color:: The hex string for the color of the dataset.  Defaults to nil.
  #
  # ==== Exceptions
  # Data points contain nil values::
  #   This error will get raised if either the x or y axis data points array
  #   contains a <tt>nil</tt> value.  The graph will not make an assumption
  #   as how to graph <tt>nil</tt>
  # x_data_points is empty::
  #   This error is raised when the array for the x-axis points are empty
  # y_data_points is empty::
  #   This error is raised when the array for the y-axis points are empty
  # x_data_points.length != y_data_points.length::
  #   Error means that the x and y axis point arrays do not match in length
  #
  # ==== Examples
  # g = Gruff::Scatter.new
  # g.data(:apples, [1,2,3], [3,2,1])
  # g.data('oranges', [1,1,1], [2,3,4])
  # g.data('bitter_melon', [3,5,6], [6,7,8], '#000000')
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

    if @maximum_x_value.nil? && @minimum_x_value.nil?
      @maximum_x_value = @minimum_x_value = x_data_points.first
    end

    @maximum_x_value = x_data_points.max > @maximum_x_value ? x_data_points.max : @maximum_x_value
    @minimum_x_value = x_data_points.min < @minimum_x_value ? x_data_points.min : @minimum_x_value
  end

  alias dataxy data

protected

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

      @marker_count = (@x_spread / @x_axis_increment).to_i
      @x_increment = @x_axis_increment
    end
    @increment_x_scaled = @graph_width.to_f / (@x_spread / @x_increment)

    # Draw vertical line markers and annotate with numbers
    (0..@marker_x_count).each do |index|
      # TODO: Fix the vertical lines, and enable them by default. Not pretty when they don't match up with top y-axis line
      if @enable_vertical_line_markers
        x = @graph_left + @graph_width - index.to_f * @increment_x_scaled
        Gruff::Renderer::Line.new(color: @marker_color).render(x, @graph_top, x, @graph_bottom)
      end

      unless @hide_line_numbers
        marker_label = index * @x_increment + @minimum_x_value.to_f
        y_offset = @graph_bottom + (@x_label_margin || LABEL_MARGIN)
        x_offset = get_x_coord(index.to_f, @increment_x_scaled, @graph_left)

        label = vertical_label(marker_label, @x_increment)
        rotation = -90.0 if @use_vertical_x_labels
        text_renderer = Gruff::Renderer::Text.new(label, font: @font, size: @marker_font_size, color: @font_color, rotation: rotation)
        text_renderer.render(1.0, 1.0, x_offset, y_offset)
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

private

  def get_x_coord(x_data_point, width, offset) #:nodoc:
    x_data_point * width + offset
  end
end

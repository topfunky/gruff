# frozen_string_literal: true

#
# Here's how to make a Gruff::Line.
#
#   g = Gruff::Line.new
#   g.title = "A Line Graph"
#   g.data 'Fries', [20, 23, 19, 8]
#   g.data 'Hamburgers', [50, 19, 99, 29]
#   g.write("line.png")
#
# There are also other options described below, such as {#baseline_value}, {#baseline_color},
# {#hide_dots=}, and {#hide_lines=}.
#
class Gruff::Line < Gruff::Base
  # Allow for reference lines ( which are like baseline ... just allowing for more & on both axes ).
  attr_accessor :reference_lines
  attr_writer :reference_line_default_color
  attr_writer :reference_line_default_width

  # Allow for vertical marker lines.
  attr_writer :show_vertical_markers

  # Dimensions of lines and dots; calculated based on dataset size if left unspecified.
  attr_writer :line_width
  attr_writer :dot_radius

  # default is +'circle'+, other options include square.
  attr_writer :dot_style

  # Hide parts of the graph to fit more data points, or for a different appearance.
  attr_writer :hide_dots, :hide_lines

  # accessors for support of xy data.
  attr_writer :minimum_x_value

  # accessors for support of xy data.
  attr_writer :maximum_x_value

  # The number of vertical lines shown.
  attr_writer :marker_x_count

  # Call with target pixel width of graph (+800+, +400+, +300+), and/or +false+ to omit lines (points only).
  #
  #   g = Gruff::Line.new(400) # 400px wide with lines
  #   g = Gruff::Line.new(400, false) # 400px wide, no lines (for backwards compatibility)
  #   g = Gruff::Line.new(false) # Defaults to 800px wide, no lines (for backwards compatibility)
  #
  # The preferred way is to call {#hide_dots=} or {#hide_lines=} instead.
  def initialize(*args)
    raise ArgumentError, 'Wrong number of arguments' if args.length > 2

    if args.empty? || (!args.first.is_a?(Numeric) && !args.first.is_a?(String))
      super()
    else
      super args.shift
    end
  end

  # Get the value if somebody has defined it.
  def baseline_value
    if @reference_lines.key?(:baseline)
      @reference_lines[:baseline][:value]
    end
  end

  # Set a value for a baseline reference line..
  def baseline_value=(new_value)
    @reference_lines[:baseline] ||= {}
    @reference_lines[:baseline][:value] = new_value
  end

  def baseline_color
    if @reference_lines.key?(:baseline)
      @reference_lines[:baseline][:color]
    end
  end

  def baseline_color=(new_value)
    @reference_lines[:baseline] ||= {}
    @reference_lines[:baseline][:color] = new_value
  end

  # This method allows one to plot a dataset with both X and Y data.
  #
  # @overload dataxy(name, x_data_points = [], y_data_points = [], color = nil)
  #   @param name [String] the title of the dataset.
  #   @param x_data_points [Array] an array containing the x data points for the graph.
  #   @param y_data_points [Array] an array containing the y data points for the graph.
  #   @param color [String] hex number indicating the line color as an RGB triplet.
  #
  # @overload dataxy(name, xy_data_points = [], color = nil)
  #   @param name [String] the title of the dataset.
  #   @param xy_data_points [Array] an array containing both x and y data points for the graph.
  #   @param color [String] hex number indicating the line color as an RGB triplet.
  #
  # @note
  #   - if (x_data_points.length != y_data_points.length) an error is
  #     returned.
  #   - if the color argument is nil, the next color from the default theme will
  #     be used.
  #   - if you want to use a preset theme, you must set it before calling {#dataxy}.
  #
  # @example
  #   g = Gruff::Line.new
  #   g.title = "X/Y Dataset"
  #   g.dataxy("Apples", [1,3,4,5,6,10], [1, 2, 3, 4, 4, 3])
  #   g.dataxy("Bapples", [1,3,4,5,7,9], [1, 1, 2, 2, 3, 3])
  #   g.dataxy("Capples", [[1,1],[2,3],[3,4],[4,5],[5,7],[6,9]])
  #
  #   # you can still use the old data method too if you want:
  #   g.data("Capples", [1, 1, 2, 2, 3, 3])
  #
  #   # labels will be drawn at the x locations of the keys passed in.
  #   In this example the labels are drawn at x positions 2, 4, and 6:
  #   g.labels = {0 => '2003', 2 => '2004', 4 => '2005', 6 => '2006'}
  #   # The 0 => '2003' label will be ignored since it is outside the chart range.
  def dataxy(name, x_data_points = [], y_data_points = [], color = nil)
    # make sure it's an array
    x_data_points = Array(x_data_points)

    raise ArgumentError, 'x_data_points is nil!' if x_data_points.empty?

    if x_data_points.all? { |p| p.is_a?(Array) && p.size == 2 }
      color = y_data_points if y_data_points.is_a?(String)
      x_data_points, y_data_points = x_data_points.transpose
    else
      y_data_points = Array(y_data_points)
    end

    raise ArgumentError, 'x_data_points.length != y_data_points.length!' if x_data_points.length != y_data_points.length

    # call the existing data routine for the x/y data.
    store.add(name, y_data_points, color, x_data_points)
  end

private

  def initialize_store
    @store = Gruff::Store.new(Gruff::Store::XYData)
  end

  def initialize_attributes
    super
    @reference_lines = {}
    @reference_line_default_color = 'red'
    @reference_line_default_width = 5

    @hide_dots = @hide_lines = false
    @maximum_x_value = nil
    @minimum_x_value = nil
    @marker_x_count = nil

    @line_width = nil
    @dot_radius = nil
    @dot_style = 'circle'

    @show_vertical_markers = false
  end

  def draw_reference_line(reference_line, left, right, top, bottom)
    color = reference_line[:color] || @reference_line_default_color
    width = reference_line[:width] || @reference_line_default_width
    Gruff::Renderer::DashLine.new(renderer, color: color, width: width).render(left, top, right, bottom)
  end

  def draw_horizontal_reference_line(reference_line)
    level = @graph_top + (@graph_height - (reference_line[:norm_value] * @graph_height))
    draw_reference_line(reference_line, @graph_left, @graph_left + @graph_width, level, level)
  end

  def draw_vertical_reference_line(reference_line)
    index = @graph_left + (@x_increment * reference_line[:index])
    draw_reference_line(reference_line, index, index, @graph_top, @graph_top + @graph_height)
  end

  def draw_graph
    # Check to see if more than one datapoint was given. NaN can result otherwise.
    @x_increment = column_count > 1 ? @graph_width / (column_count - 1) : @graph_width

    @reference_lines.each_value do |curr_reference_line|
      draw_horizontal_reference_line(curr_reference_line) if curr_reference_line.key?(:norm_value)
      draw_vertical_reference_line(curr_reference_line) if curr_reference_line.key?(:index)
    end

    store.norm_data.each do |data_row|
      prev_x = prev_y = nil

      one_point = contains_one_point_only?(data_row)

      data_row.coordinates.each_with_index do |(x_data, y_data), index|
        if x_data.nil?
          # use the old method: equally spaced points along the x-axis
          new_x = @graph_left + (@x_increment * index)
          draw_label(new_x, index)
        else
          new_x = get_x_coord(x_data, @graph_width, @graph_left)
          @labels.each do |label_pos, _|
            draw_label(@graph_left + (((label_pos - @minimum_x_value) * @graph_width) / (@maximum_x_value - @minimum_x_value)), label_pos)
          end
        end
        unless y_data # we can't draw a line for a null data point, we can still label the axis though
          prev_x = prev_y = nil
          next
        end

        new_y = @graph_top + (@graph_height - (y_data * @graph_height))

        # Reset each time to avoid thin-line errors
        stroke_width  = @line_width || clip_value_if_greater_than(@columns / (store.norm_data.first.y_points.size * 4), 5.0)
        circle_radius = @dot_radius || clip_value_if_greater_than(@columns / (store.norm_data.first.y_points.size * 2.5), 5.0)

        if !@hide_lines && prev_x && prev_y
          Gruff::Renderer::Line.new(renderer, color: data_row.color, width: stroke_width)
                               .render(prev_x, prev_y, new_x, new_y)
        end

        if one_point || !@hide_dots
          Gruff::Renderer::Dot.new(renderer, @dot_style, color: data_row.color, width: stroke_width).render(new_x, new_y, circle_radius)
        end

        prev_x = new_x
        prev_y = new_y
      end
    end
  end

  def setup_data
    # Update the global min/max values for the x data
    @maximum_x_value = (@maximum_x_value || store.max_x).to_f
    @minimum_x_value = (@minimum_x_value || store.min_x).to_f

    # Deal with horizontal reference line values that exceed the existing minimum & maximum values.
    possible_maximums = [maximum_value]
    possible_minimums = [minimum_value]

    @reference_lines.each_value do |curr_reference_line|
      if curr_reference_line.key?(:value)
        possible_maximums << curr_reference_line[:value].to_f
        possible_minimums << curr_reference_line[:value].to_f
      end
    end

    self.maximum_value = possible_maximums.max
    self.minimum_value = possible_minimums.min

    super
  end

  def setup_drawing
    @marker_x_count ||= column_count - 1
    super
  end

  def normalize
    return unless data_given?

    spread_x = @maximum_x_value - @minimum_x_value
    store.normalize(minimum_x: @minimum_x_value, spread_x: spread_x, minimum_y: minimum_value, spread_y: @spread)

    @reference_lines.each_value do |curr_reference_line|
      # We only care about horizontal markers ... for normalization.
      # Vertical markers won't have a :value, they will have an :index

      curr_reference_line[:norm_value] = ((curr_reference_line[:value].to_f - minimum_value) / @spread) if curr_reference_line.key?(:value)
    end
  end

  def draw_line_markers
    # do all of the stuff for the horizontal lines on the y-axis
    super
    return if @hide_line_markers

    (0..@marker_x_count).each do |index|
      if @show_vertical_markers
        x = @graph_left + @graph_width - (index * @graph_width / @marker_x_count)

        Gruff::Renderer::Line.new(renderer, color: @marker_color).render(x, @graph_bottom, x, @graph_top)
        # If the user specified a marker shadow color, draw a shadow just below it
        if @marker_shadow_color
          Gruff::Renderer::Line.new(renderer, color: @marker_shadow_color).render(x + 1, @graph_bottom, x + 1, @graph_top)
        end
      end
    end
  end

  def get_x_coord(x_data_point, width, offset)
    (x_data_point * width) + offset
  end

  def contains_one_point_only?(data_row)
    data_row.y_points.compact.count == 1
  end
end

require File.dirname(__FILE__) + '/base'

##
# Here's how to make a Line graph:
#
#   g = Gruff::Line.new
#   g.title = "A Line Graph"
#   g.data 'Fries', [20, 23, 19, 8]
#   g.data 'Hamburgers', [50, 19, 99, 29]
#   g.write("test/output/line.png")
#
# There are also other options described below, such as #baseline_value, #baseline_color, #hide_dots, and #hide_lines.

class Gruff::Line < Gruff::Base

  # Allow for reference lines ( which are like baseline ... just allowing for more & on both axes )
  attr_accessor :reference_lines
  attr_accessor :reference_line_default_color
  attr_accessor :reference_line_default_width

  # Allow for vertical marker lines
  attr_accessor :show_vertical_markers

  # Dimensions of lines and dots; calculated based on dataset size if left unspecified
  attr_accessor :line_width
  attr_accessor :dot_radius

  # default is a circle, other options include square
  attr_accessor :dot_style

  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots, :hide_lines

  #accessors for support of xy data
  attr_accessor :minimum_x_value
  attr_accessor :maximum_x_value

  # Get the value if somebody has defined it.
  def baseline_value
    if (@reference_lines.key?(:baseline))
      @reference_lines[:baseline][:value]
    else
      nil
    end
  end

  # Set a value for a baseline reference line..
  def baseline_value=(new_value)
    @reference_lines[:baseline] ||= Hash.new
    @reference_lines[:baseline][:value] = new_value
  end

  def baseline_color
    if (@reference_lines.key?(:baseline))
      @reference_lines[:baseline][:color]
    else
      nil
    end
  end

  def baseline_color=(new_value)
    @reference_lines[:baseline] ||= Hash.new
    @reference_lines[:baseline][:color] = new_value
  end

  # Call with target pixel width of graph (800, 400, 300), and/or 'false' to omit lines (points only).
  #
  #  g = Gruff::Line.new(400) # 400px wide with lines
  #
  #  g = Gruff::Line.new(400, false) # 400px wide, no lines (for backwards compatibility)
  #
  #  g = Gruff::Line.new(false) # Defaults to 800px wide, no lines (for backwards compatibility)
  #
  # The preferred way is to call hide_dots or hide_lines instead.
  def initialize(*args)
    raise ArgumentError, 'Wrong number of arguments' if args.length > 2
    if args.empty? || ((not Numeric === args.first) && (not String === args.first))
      super()
    else
      super args.shift
    end

    @reference_lines = Hash.new
    @reference_line_default_color = 'red'
    @reference_line_default_width = 5

    @hide_dots = @hide_lines = false
    @maximum_x_value = nil
    @minimum_x_value = nil

    @dot_style = 'circle'

    @show_vertical_markers = false
  end

  # This method allows one to plot a dataset with both X and Y data.
  #
  # Parameters are as follows:
  #   name: string, the title of the dataset
  #   x_data_points: an array containing the x data points for the graph
  #   y_data_points: an array containing the y data points for the graph
  #   color: hex number indicating the line color as an RGB triplet
  #
  #   or
  #
  #   name: string, the title of the dataset
  #   xy_data_points: an array containing both x and y data points for the graph
  #   color: hex number indicating the line color as an RGB triplet
  #
  #  Notes:
  #   -if (x_data_points.length != y_data_points.length) an error is
  #     returned.
  #   -if the color argument is nil, the next color from the default theme will
  #     be used.
  #   -if you want to use a preset theme, you must set it before calling
  #     dataxy().
  #
  # Example:
  #   g = Gruff::Line.new
  #   g.title = "X/Y Dataset"
  #   g.dataxy("Apples", [1,3,4,5,6,10], [1, 2, 3, 4, 4, 3])
  #   g.dataxy("Bapples", [1,3,4,5,7,9], [1, 1, 2, 2, 3, 3])
  #   g.dataxy("Capples", [[1,1],[2,3],[3,4],[4,5],[5,7],[6,9]])
  #   #you can still use the old data method too if you want:
  #   g.data("Capples", [1, 1, 2, 2, 3, 3])
  #   #labels will be drawn at the x locations of the keys passed in.
  #   In this example the lables are drawn at x positions 2, 4, and 6:
  #   g.labels = {0 => '2003', 2 => '2004', 4 => '2005', 6 => '2006'}
  #   The 0 => '2003' label will be ignored since it is outside the chart range.
  def dataxy(name, x_data_points=[], y_data_points=[], color=nil)
    raise ArgumentError, 'x_data_points is nil!' if x_data_points.length == 0

    if x_data_points.all? { |p| p.is_a?(Array) && p.size == 2 }
      x_data_points, y_data_points = x_data_points.map { |p| p[0] }, x_data_points.map { |p| p[1] }
    end

    raise ArgumentError, 'x_data_points.length != y_data_points.length!' if x_data_points.length != y_data_points.length

    # call the existing data routine for the y data.
    self.data(name, y_data_points, color)

    x_data_points = Array(x_data_points) # make sure it's an array
    # append the x data to the last entry that was just added in the @data member
    @data.last[DATA_VALUES_X_INDEX] = x_data_points

    # Update the global min/max values for the x data
    x_data_points.each do |x_data_point|
      next if x_data_point.nil?

      # Setup max/min so spread starts at the low end of the data points
      if @maximum_x_value.nil? && @minimum_x_value.nil?
        @maximum_x_value = @minimum_x_value = x_data_point
      end

      @maximum_x_value = (x_data_point > @maximum_x_value) ?
          x_data_point : @maximum_x_value
      @minimum_x_value = (x_data_point < @minimum_x_value) ?
          x_data_point : @minimum_x_value
    end

  end

  def draw_reference_line(reference_line, left, right, top, bottom)
    @d = @d.push
    @d.stroke_color(reference_line[:color] || @reference_line_default_color)
    @d.fill_opacity 0.0
    @d.stroke_dasharray(10, 20)
    @d.stroke_width(reference_line[:width] || @reference_line_default_width)
    @d.line(left, top, right, bottom)
    @d = @d.pop
  end

  def draw_horizontal_reference_line(reference_line)
    level = @graph_top + (@graph_height - reference_line[:norm_value] * @graph_height)
    draw_reference_line(reference_line, @graph_left, @graph_left + @graph_width, level, level)
  end

  def draw_vertical_reference_line(reference_line)
    index = @graph_left + (@x_increment * reference_line[:index])
    draw_reference_line(reference_line, index, index, @graph_top, @graph_top + @graph_height)
  end

  def draw
    super

    return unless @has_data

    # Check to see if more than one datapoint was given. NaN can result otherwise.
    @x_increment = (@column_count > 1) ? (@graph_width / (@column_count - 1).to_f) : @graph_width

    @reference_lines.each_value do |curr_reference_line|
      draw_horizontal_reference_line(curr_reference_line) if curr_reference_line.key?(:norm_value)
      draw_vertical_reference_line(curr_reference_line) if curr_reference_line.key?(:index)
    end

    if (@show_vertical_markers)
      (0..@column_count).each do |column|
        x = @graph_left + @graph_width - column.to_f * @x_increment

        @d = @d.fill(@marker_color)

        # FIXME(uwe): Workaround for Issue #66
        #             https://github.com/topfunky/gruff/issues/66
        #             https://github.com/rmagick/rmagick/issues/82
        #             Remove if the issue gets fixed.
        x += 0.001 unless defined?(JRUBY_VERSION)
        # EMXIF

        @d = @d.line(x, @graph_bottom, x, @graph_top)
        #If the user specified a marker shadow color, draw a shadow just below it
        unless @marker_shadow_color.nil?
          @d = @d.fill(@marker_shadow_color)
          @d = @d.line(x + 1, @graph_bottom, x + 1, @graph_top)
        end
      end
    end

    @norm_data.each do |data_row|
      prev_x = prev_y = nil

      @one_point = contains_one_point_only?(data_row)

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        x_data = data_row[DATA_VALUES_X_INDEX]
        if x_data == nil
          #use the old method: equally spaced points along the x-axis
          new_x = @graph_left + (@x_increment * index)
          draw_label(new_x, index)
        else
          new_x = get_x_coord(x_data[index], @graph_width, @graph_left)
          @labels.each do |label_pos, _|
            draw_label(@graph_left + ((label_pos - @minimum_x_value) * @graph_width) / (@maximum_x_value - @minimum_x_value), label_pos)
          end
        end
        unless data_point # we can't draw a line for a null data point, we can still label the axis though
          prev_x = prev_y = nil
          next
        end

        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        # Reset each time to avoid thin-line errors
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke_opacity 1.0
        @d = @d.stroke_width line_width ||
                                 clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)

        circle_radius = dot_radius ||
            clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)

        if !@hide_lines && !prev_x.nil? && !prev_y.nil?
          @d = @d.line(prev_x, prev_y, new_x, new_y)
        elsif @one_point
          # Show a circle if there's just one_point
          @d = DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        unless @hide_dots
          @d = DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        prev_x, prev_y = new_x, new_y
      end
    end

    @d.draw(@base_image)
  end

  def setup_data

    # Deal with horizontal reference line values that exceed the existing minimum & maximum values.
    possible_maximums = [@maximum_value.to_f]
    possible_minimums = [@minimum_value.to_f]

    @reference_lines.each_value do |curr_reference_line|
      if (curr_reference_line.key?(:value))
        possible_maximums << curr_reference_line[:value].to_f
        possible_minimums << curr_reference_line[:value].to_f
      end
    end

    @maximum_value = possible_maximums.max
    @minimum_value = possible_minimums.min

    super
  end

  def normalize(force=false)
    super(force)

    @reference_lines.each_value do |curr_reference_line|

      # We only care about horizontal markers ... for normalization.
      # Vertical markers won't have a :value, they will have an :index

      curr_reference_line[:norm_value] = ((curr_reference_line[:value].to_f - @minimum_value) / @spread.to_f) if (curr_reference_line.key?(:value))

    end

    #normalize the x data if it is specified
    @data.each_with_index do |data_row, index|
      norm_x_data_points = []
      if data_row[DATA_VALUES_X_INDEX] != nil
        data_row[DATA_VALUES_X_INDEX].each do |x_data_point|
          norm_x_data_points << ((x_data_point.to_f - @minimum_x_value.to_f) /
              (@maximum_x_value.to_f - @minimum_x_value.to_f))
        end
        @norm_data[index] << norm_x_data_points
      end
    end

  end

  def sort_norm_data
    super unless @data.any? { |d| d[DATA_VALUES_X_INDEX] }
  end

  def get_x_coord(x_data_point, width, offset)
    x_data_point * width + offset
  end

  def contains_one_point_only?(data_row)
    # Spin through data to determine if there is just one_value present.
    one_point = false
    data_row[DATA_VALUES_INDEX].each do |data_point|
      unless data_point.nil?
        if one_point
          # more than one point, bail
          return false
        end
        # there is at least one data point
        one_point = true
      end
    end
    one_point
  end

  module DotRenderers
    class Circle
      def render(d, new_x, new_y, circle_radius)
        d.circle(new_x, new_y, new_x - circle_radius, new_y)
      end
    end

    class Square
      def render(d, new_x, new_y, circle_radius)
        offset = (circle_radius * 0.8).to_i
        corner_1 = new_x - offset
        corner_2 = new_y - offset
        corner_3 = new_x + offset
        corner_4 = new_y + offset
        d.rectangle(corner_1, corner_2, corner_3, corner_4)
      end
    end

    def self.renderer(style)
      if style.to_s == 'square'
        Square.new
      else
        Circle.new
      end
    end
  end
end

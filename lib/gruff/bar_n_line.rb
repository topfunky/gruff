require File.dirname(__FILE__) + '/base'

##
# Original Author: Hoang Nguyen Minh
#
# This class is used to create a chart with bars and lines
#
class Gruff::BarNLine < Gruff::Bar

  attr_accessor :line_width

  attr_accessor :dot_radius

  attr_accessor :hide_dots

  # Allow for reference lines ( which are like baseline ... just allowing for more & on both axes )
  attr_accessor :reference_lines
  attr_accessor :reference_line_default_color
  attr_accessor :reference_line_default_width

  def initialize(*args)
    super

    @line_width = 3
    @dot_radius = 3
    @hide_dots = false

    @reference_lines = Hash.new
    @reference_line_default_color = 'red'
    @reference_line_default_width = 5
  end

  def right_y_axis=(axis)
    super

    pre_normalize if !@right_y_axis.nil? && count_rows(:secondary) > 0
  end

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

  def data_line(name, data_points=[], color=nil)
    data_points = Array(data_points) # make sure it's an array
    @data << [name, data_points, color]
    @data.last[DATA_ROLE_INDEX] = ROLE_SECONDARY

    # Set column count if this is larger than previous counts
    @column_count = (data_points.length > @column_count) ? data_points.length : @column_count

    return if @right_y_axis.nil?
    # Pre-normalize for secondary y-axis
    data_points.each do |data_point|
      next if data_point.nil?

      # Setup max/min so spread starts at the low end of the data points
      if @right_y_axis.maximum_value.nil? && @right_y_axis.minimum_value.nil?
        @right_y_axis.maximum_value = @right_y_axis.minimum_value = data_point
      end

      # TODO Doesn't work with stacked bar graphs
      # Original: @maximum_value = larger_than_max?(data_point, index) ? max(data_point, index) : @maximum_value
      @right_y_axis.maximum_value = data_point > @right_y_axis.maximum_value ? data_point : @right_y_axis.maximum_value
      @has_data = true if @right_y_axis.maximum_value >= 0

      @right_y_axis.minimum_value = data_point < @right_y_axis.minimum_value ? data_point : @right_y_axis.minimum_value
      @has_data = true if @right_y_axis.minimum_value < 0
    end
  end

  protected

  def pre_normalize
    @data.each do |data_row|
      data_row[DATA_VALUES_INDEX].each do |data_point|
        next if data_point.nil?

        # Setup max/min so spread starts at the low end of the data points
        if @right_y_axis.maximum_value.nil? && @right_y_axis.minimum_value.nil?
          @right_y_axis.maximum_value = @right_y_axis.minimum_value = data_point
        end

        # TODO Doesn't work with stacked bar graphs
        # Original: @maximum_value = larger_than_max?(data_point, index) ? max(data_point, index) : @maximum_value
        @right_y_axis.maximum_value = data_point > @right_y_axis.maximum_value ? data_point : @right_y_axis.maximum_value
        @has_data = true if @right_y_axis.maximum_value >= 0

        @right_y_axis.minimum_value = data_point < @right_y_axis.minimum_value ? data_point : @right_y_axis.minimum_value
        @has_data = true if @right_y_axis.minimum_value < 0
      end
    end
  end

  def normalize(force=false)
    @reference_lines.each_value do |curr_reference_line|
      # We only care about horizontal markers ... for normalization.
      # Vertical markers won't have a :value, they will have an :index
      if @right_y_axis.nil?
        curr_reference_line[:norm_value] = ((curr_reference_line[:value].to_f - @minimum_value) / @spread.to_f) if (curr_reference_line.key?(:value))
      else
        curr_reference_line[:norm_value] = ((curr_reference_line[:value].to_f - @right_y_axis.minimum_value) / @right_y_axis.m_spread.to_f) if (curr_reference_line.key?(:value))
      end
    end
    if @norm_data.nil? || force
      @norm_data = []
      return unless @has_data

      @data.each do |data_row|
        norm_data_points = []
        data_row[DATA_VALUES_INDEX].each do |data_point|
          if data_point.nil?
            norm_data_points << nil
          else
            if data_row[DATA_ROLE_INDEX] == ROLE_SECONDARY && !@right_y_axis.nil?
              norm_data_points << ((data_point.to_f - @right_y_axis.minimum_value.to_f) / @right_y_axis.m_spread)
            else
              norm_data_points << ((data_point.to_f - @minimum_value.to_f) / @spread)
            end
          end
        end
        if @show_labels_for_bar_values
          @norm_data << [data_row[DATA_LABEL_INDEX], norm_data_points, data_row[DATA_COLOR_INDEX], data_row[DATA_VALUES_INDEX], data_row[DATA_ROLE_INDEX]]
        else
          @norm_data << [data_row[DATA_LABEL_INDEX], norm_data_points, data_row[DATA_COLOR_INDEX], nil, data_row[DATA_ROLE_INDEX]]
        end
      end
    end
  end

  def setup_data
    unless @right_y_axis.nil?
      # Deal with horizontal reference line values that exceed the existing minimum & maximum values.
      possible_maximums = [@right_y_axis.maximum_value.to_f]
      possible_minimums = [@right_y_axis.minimum_value.to_f]

      @reference_lines.each_value do |curr_reference_line|
        if (curr_reference_line.key?(:value))
          possible_maximums << curr_reference_line[:value].to_f
          possible_minimums << curr_reference_line[:value].to_f
        end
      end

      @right_y_axis.maximum_value = possible_maximums.max
      @right_y_axis.minimum_value = possible_minimums.min
    end

    super
  end

  def count_rows(role)
    count = 0
    @data.each do |row|
      count += 1 if row[DATA_ROLE_INDEX] == role
    end
    count
  end

  def draw_bars
    primary_rows = count_rows :primary
    @x_increment = (@column_count > 1) ? (@graph_width / (@column_count - 1).to_f) : @graph_width
    # Setup spacing.
    #
    # Columns sit side-by-side.
    col_space = @data_column_spacing * @graph_width
    @bar_spacing ||= @spacing_factor # space between the bars
    @bar_width = (@graph_width - col_space) / (@column_count * primary_rows).to_f
    padding = (@bar_width * (1 - @bar_spacing)) / 2
    margin = [col_space / (@column_count - 1), 0].max

    @d = @d.stroke_opacity 0.0

    @reference_lines.each_value do |curr_reference_line|
      draw_horizontal_reference_line(curr_reference_line) if curr_reference_line.key?(:norm_value)
      draw_vertical_reference_line(curr_reference_line, @bar_width, margin, primary_rows) if curr_reference_line.key?(:index)
    end

    # Setup the BarConversion Object
    conversion = Gruff::BarConversion.new()
    conversion.graph_height = @graph_height
    conversion.graph_top = @graph_top

    # Set up the right mode [1,2,3] see BarConversion for further explanation
    if @minimum_value >= 0
      # all bars go from zero to positiv
      conversion.mode = 1
    else
      # all bars go from 0 to negativ
      if @maximum_value <= 0
        conversion.mode = 2
      else
        # bars either go from zero to negativ or to positiv
        conversion.mode = 3
        conversion.spread = @spread
        conversion.minimum_value = @minimum_value
        conversion.zero = -@minimum_value/@spread
      end
    end

    # iterate over all normalised data
    @norm_data.each_with_index do |data_row, row_index|
      next if data_row[DATA_ROLE_INDEX] != ROLE_PRIMARY
      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
        # Use incremented x and scaled y
        # x
        left_x = @graph_left + (@bar_width * (row_index + point_index + ((primary_rows - 1) * point_index))) + padding + point_index * margin
        right_x = left_x + @bar_width * @bar_spacing
        # y
        conv = []
        conversion.get_left_y_right_y_scaled( data_point, conv )

        # create new bar
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.rectangle(left_x, conv[0], right_x, conv[1])

        # Calculate center based on bar_width and current row
        label_center = @graph_left +
                      (primary_rows * @bar_width * point_index) +
                      (primary_rows * @bar_width / 2.0) +
                      point_index * margin

        # Subtract half a bar width to center left if requested
        draw_label(label_center - (@center_labels_over_point ? @bar_width / 2.0 : 0.0), point_index)
        if @show_labels_for_bar_values
          val = (@label_formatting || '%.2f') % @norm_data[row_index][3][point_index]
          draw_value_label(left_x + (right_x - left_x)/2, conv[0]-30, val.commify, true)
        end
      end
    end

    @norm_data.each_with_index do |data_row, row_index|
      next if data_row[DATA_ROLE_INDEX] != ROLE_SECONDARY
      prev_x = prev_y = nil

      @one_point = contains_one_point_only?(data_row)

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        unless data_point
          prev_x = prev_y = nil
          next
        end

        # Calculate center based on bar_width and current row
        new_x = @graph_left +
                (primary_rows * @bar_width * index) +
                (primary_rows * @bar_width / 2.0) +
                index * margin

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
          @d = Gruff::Line::DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        unless @hide_dots
         @d = Gruff::Line::DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        prev_x, prev_y = new_x, new_y
      end
    end

    # Draw the last label if requested
    draw_label(@graph_right, @column_count) if @center_labels_over_point

    @d.draw(@base_image)
  end

  private

  def draw_horizontal_reference_line(reference_line)
    level = @graph_top + (@graph_height - reference_line[:norm_value] * @graph_height)
    draw_reference_line(reference_line, @graph_left, @graph_left + @graph_width, level, level)
  end

  def draw_vertical_reference_line(reference_line, bar_width, margin, cols)
    index = @graph_left +
                (cols * bar_width * reference_line[:index]) +
                (cols * bar_width / 2.0) +
                reference_line[:index] * margin
    draw_reference_line(reference_line, index, index, @graph_top, @graph_top + @graph_height)
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
end
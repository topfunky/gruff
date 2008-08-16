
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

  # Draw a dashed line at the given value
  attr_accessor :baseline_value
	
  # Color of the baseline
  attr_accessor :baseline_color
  
  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots, :hide_lines

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
    raise ArgumentError, "Wrong number of arguments" if args.length > 2
    if args.empty? or ((not Numeric === args.first) && (not String === args.first)) then
      super()
    else
      super args.shift
    end
    
    @hide_dots = @hide_lines = false
    @baseline_color = 'red'
    @baseline_value = nil
  end

  def draw
    super

    return unless @has_data
    
    # Check to see if more than one datapoint was given. NaN can result otherwise.  
    @x_increment = (@column_count > 1) ? (@graph_width / (@column_count - 1).to_f) : @graph_width
     
    if (defined?(@norm_baseline)) then
      level = @graph_top + (@graph_height - @norm_baseline * @graph_height)
      @d = @d.push
      @d.stroke_color @baseline_color
      @d.fill_opacity 0.0
      @d.stroke_dasharray(10, 20)
      @d.stroke_width 5
      @d.line(@graph_left, level, @graph_left + @graph_width, level)
      @d = @d.pop
    end

    @norm_data.each do |data_row|      
      prev_x = prev_y = nil

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        new_x = @graph_left + (@x_increment * index)
        next if data_point.nil?

        draw_label(new_x, index)

        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        # Reset each time to avoid thin-line errors
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke_opacity 1.0
        @d = @d.stroke_width clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)

        if !@hide_lines and !prev_x.nil? and !prev_y.nil? then          
          @d = @d.line(prev_x, prev_y, new_x, new_y)
        end
        circle_radius = clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)
        @d = @d.circle(new_x, new_y, new_x - circle_radius, new_y) unless @hide_dots

        prev_x = new_x
        prev_y = new_y
      end

    end

    @d.draw(@base_image)
  end

  def normalize
    @maximum_value = [@maximum_value.to_f, @baseline_value.to_f].max
    super
    @norm_baseline = (@baseline_value.to_f / @maximum_value.to_f) if @baseline_value
  end
  
end

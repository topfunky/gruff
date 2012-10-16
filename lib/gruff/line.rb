
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
  
  # Dimensions of lines and dots; calculated based on dataset size if left unspecified
  attr_accessor :line_width
  attr_accessor :dot_radius

  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots, :hide_lines
  
  #accessors for support of xy data
  attr_accessor :minimum_x_value
  attr_accessor :maximum_x_value

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
    @maximum_x_value = nil
    @minimum_x_value = nil
  end
  
  # This method allows one to plot a dataset with both X and Y data.
  #
  # Parameters are as follows:
  #   name: string, the title of the dataset
  #   x_data_points: an array containing the x data points for the graph
  #   y_data_points: an array containing the y data points for the graph
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
  #   #you can still use the old data method too if you want:
  #   g.data("Capples", [1, 1, 2, 2, 3, 3])  
  #   #labels will be drawn at the x locations of the 1st dataset that you 
  #   #passed in.  In this example the lables are drawn at x locations 1,4,6
  #   g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}  #labels
 
  def dataxy(name, x_data_points=[], y_data_points=[], color=nil)
    raise ArgumentError, "x_data_points is nil!" if x_data_points.length == 0

    if x_data_points.all?{|p| p.size == 2}
      x_data_points, y_data_points = x_data_points.map{|p| p[0]}, x_data_points.map{|p| p[1]}
    end

    raise ArgumentError, "x_data_points.length != y_data_points.length!" if x_data_points.length != y_data_points.length

    #call the existing data routine for the y data.
    self.data(name, y_data_points, color)
    
    x_data_points = Array(x_data_points) # make sure it's an array
    #append the x data to the last entry that was just added in the @data member
    lastElem = @data.length()-1
    @data[lastElem][DATA_VALUES_X_INDEX] = x_data_points
    
    # Update the global min/max values for the x data
    x_data_points.each_with_index do |x_data_point, index|
      next if x_data_point.nil?
      
      # Setup max/min so spread starts at the low end of the data points
      if @maximum_x_value.nil? && @minimum_x_value.nil?
        @maximum_x_value = @minimum_x_value = x_data_point
      end
      
      @maximum_x_value = (x_data_point >  @maximum_x_value) ? 
      x_data_point : @maximum_x_value
      @minimum_x_value = (x_data_point < @minimum_x_value) ? 
      x_data_point : @minimum_x_value
    end
    
  end

  def draw
    super

    return unless @has_data
    
    # Check to see if more than one datapoint was given. NaN can result otherwise.  
    @x_increment = (@column_count > 1) ? (@graph_width / (@column_count - 1).to_f) : @graph_width

    #normalize the x data if it is specified
    @data.each_with_index do |data_row, index|
      norm_x_data_points = []
      if (data_row[DATA_VALUES_X_INDEX] != nil)
        data_row[DATA_VALUES_X_INDEX].each do |x_data_point|
          norm_x_data_points << ( (x_data_point.to_f - @minimum_x_value.to_f ) /
           (@maximum_x_value.to_f - @minimum_x_value.to_f) )
       end
       @norm_data[index] << norm_x_data_points
      end
    end

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

    @norm_data.each_with_index do |data_row, dr_index|
      prev_x = prev_y = nil

      @one_point = contains_one_point_only?(data_row)

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        next if data_point.nil?

        x_data = data_row[DATA_VALUES_X_INDEX]
        if (x_data == nil)
          #use the old method: equally spaced points along the x-axis
          new_x = @graph_left + (@x_increment * index)  
        else
          new_x = getXCoord(x_data[index], @graph_width, @graph_left)
        end
        
        draw_label(new_x, index)

        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        # Reset each time to avoid thin-line errors
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke_opacity 1.0
        @d = @d.stroke_width line_width ||
          clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)


        circle_radius = dot_radius ||
          clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)

        if !@hide_lines and !prev_x.nil? and !prev_y.nil? then          
          @d = @d.line(prev_x, prev_y, new_x, new_y)
        elsif @one_point
          # Show a circle if there's just one_point
          @d = @d.circle(new_x, new_y, new_x - circle_radius, new_y)
        end
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
  
  def sort_norm_data
    super unless @data.any?{|d| d[DATA_VALUES_X_INDEX]}
  end

  def getXCoord(x_data_point, width, offset)
    return(x_data_point * width + offset)
  end

  def contains_one_point_only?(data_row)
    # Spin through data to determine if there is just one_value present.
    one_point = false
    data_row[DATA_VALUES_INDEX].each do |data_point|
      if !data_point.nil?
        if one_point
          # more than one point, bail
          return false
        end
        # there is at least one data point
        one_point = true
      end
    end
    return one_point
  end

end

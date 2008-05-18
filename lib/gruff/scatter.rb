require File.dirname(__FILE__) + '/base'

# Here's how to set up the Scatter graph
#
# g = Gruff::Scatter.new(800)
# 
# In the event that someone doesn't have both the x and y points filled in 
# the data point will just get dropped from the dataset.  
#
class Gruff::Scatter < Gruff::Base

  # You can manually set a maximum x value instead of having the values
  # guessed for you.
  #
  # Set it after you have given all your data to the graph object.
  attr_accessor :maximum_x_value
  
  # You can manually set a minimum x value instead of having the values
  # guessed for you.
  #
  # Set it after you have given all your data to the graph object.
  attr_accessor :minimum_x_value
  
  # used for foring normalization of the data
  attr_accessor :xy_normalize
  
  def initialize(*args)
    super(*args)
    
    @maximum_x_value = 0
    @minimum_x_value = 0
    @xy_normalize = false
  end
  
  def draw
    calculate_spread
    @sort = false
    
    # Translate our values so that we can use the base methods for drawing
    # the standard chart stuff
    @column_count = @x_spread

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
        x_value = data_row[DATA_VALUES_X_INDEX][index]
        next if data_point.nil? || x_value.nil? 

        new_x = @graph_right - (@graph_width - x_value * @graph_width)
        new_y = @graph_top + (@graph_height - data_point * @graph_height)
        puts data_point
        puts x_value
        
        # Reset each time to avoid thin-line errors
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke_opacity 1.0
        @d = @d.stroke_width clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 4), 5.0)

        circle_radius = clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 2.5), 5.0)
        @d = @d.circle(new_x, new_y, new_x - 5, new_y)

        prev_x = new_x
        prev_y = new_y
      end

    end

    @d.draw(@base_image)
  end
  
  # Parameters are an array where the first element is the name of the dataset
  # and the value is an array of values to plot.
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
  def data(name, x_data_points=[], y_data_points=[], color=nil)
    
    raise ArgumentError, "x_data_points is nil!" if x_data_points.empty?
    raise ArgumentError, "y_data_points is nil!" if y_data_points.empty?
    raise ArgumentError, "x_data_points.length != y_data_points.length!" if x_data_points.length != y_data_points.length
    
    # Call the existing data routine for the y axis data
    super(name, y_data_points, color)
    
    #append the x data to the last entry that was just added in the @data member
    lastElem = @data.length()-1
    @data[lastElem] << x_data_points
    
    if @maximum_x_value.nil? && @minimum_x_value.nil?
      @maximum_x_value = @minimum_x_value = x_data_points.first
    end
    
    @maximum_x_value = x_data_points.max > @maximum_x_value ?
                        x_data_points.max : @maximum_x_value
    @minimum_x_value = x_data_points.min > @minimum_x_value ?
                        x_data_points.min : @minimum_x_value
  end
  
protected
  
  def calculate_spread #:nodoc:
    super
    @x_spread = @maximum_x_value.to_f - @minimum_x_value.to_f
    @x_spread = @x_spread > 0 ? @x_spread : 1
  end
  
  def normalize(force=@xy_normalize)
    if @norm_data.nil? || force 
      @norm_data = []
      return unless @has_data
      
      @data.each do |data_row|
        norm_data_points = [data_row[DATA_LABEL_INDEX]]
        norm_data_points << data_row[DATA_VALUES_INDEX].map do |r|  
                                (r.to_f - @minimum_value.to_f) / @spread
                            end
        norm_data_points << data_row[DATA_COLOR_INDEX]
        norm_data_points << data_row[DATA_VALUES_X_INDEX].map do |r|  
                                (r.to_f - @minimum_x_value.to_f) / @x_spread 
                            end
        @norm_data << norm_data_points
      end
    end
  end
  
end # end Gruff::Scatter
require File.dirname(__FILE__) + '/base'

##
# Here's how to make a Pie graph:
#
#   g = Gruff::Pie.new
#   g.title = "Visual Pie Graph Test"
#   g.data 'Fries', 20
#   g.data 'Hamburgers', 50
#   g.write("test/output/pie_keynote.png")
#
# To control where the pie chart starts creating slices, use #zero_degree.

class Gruff::Pie < Gruff::Base

  TEXT_OFFSET_PERCENTAGE = 0.15

  # Can be used to make the pie start cutting slices at the top (-90.0)
  # or at another angle. Default is 0.0, which starts at 3 o'clock.
  attr_accessor :zero_degree

  def initialize_ivars
    super
    @zero_degree = 0.0
  end

  def draw
    @hide_line_markers = true
    
    super

    return unless @has_data

    diameter = @graph_height
    radius = ([@graph_width, @graph_height].min / 2.0) * 0.8
    top_x = @graph_left + (@graph_width - diameter) / 2.0
    center_x = @graph_left + (@graph_width / 2.0)
    center_y = @graph_top + (@graph_height / 2.0) - 10 # Move graph up a bit
    total_sum = sums_for_pie()
    prev_degrees = @zero_degree

    # Use full data since we can easily calculate percentages
    data = (@sort ? @data.sort{ |a, b| a[DATA_VALUES_INDEX].first <=> b[DATA_VALUES_INDEX].first } : @data)
    data.each do |data_row|
      if data_row[DATA_VALUES_INDEX].first > 0
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill 'transparent'
        @d.stroke_width(radius) # stroke width should be equal to radius. we'll draw centered on (radius / 2)

        current_degrees = (data_row[DATA_VALUES_INDEX].first / total_sum) * 360.0 

        # ellipse will draw the the stroke centered on the first two parameters offset by the second two.
        # therefore, in order to draw a circle of the proper diameter we must center the stroke at
        # half the radius for both x and y
        @d = @d.ellipse(center_x, center_y, 
                  radius / 2.0, radius / 2.0,
                  prev_degrees, prev_degrees + current_degrees + 0.5) # <= +0.5 'fudge factor' gets rid of the ugly gaps
                  
        half_angle = prev_degrees + ((prev_degrees + current_degrees) - prev_degrees) / 2
        
        # Following line is commented to allow display of the percentiles
        # bug appeared between r90 and r92
        # unless @hide_line_markers then
          # End the string with %% to escape the single %.
          # RMagick must use sprintf with the string and % has special significance.
          label_string = ((data_row[DATA_VALUES_INDEX].first / total_sum) *
                          100.0).round.to_s + '%%'
          @d = draw_label(center_x,center_y, half_angle,
                          radius + (radius * TEXT_OFFSET_PERCENTAGE),
                          label_string)
        # end

        prev_degrees += current_degrees
      end
    end

    # TODO debug a circle where the text is drawn...
    
    @d.draw(@base_image)
  end

private

  ##
  # Labels are drawn around a slightly wider ellipse to give room for 
  # labels on the left and right.
  def draw_label(center_x, center_y, angle, radius, amount)
    # TODO Don't use so many hard-coded numbers
    r_offset = 20.0      # The distance out from the center of the pie to get point
    x_offset = center_x # + 15.0 # The label points need to be tweaked slightly
    y_offset = center_y  # This one doesn't though
    radius_offset = (radius + r_offset)
    ellipse_factor = radius_offset * 0.15
    x = x_offset + ((radius_offset + ellipse_factor) * Math.cos(angle.deg2rad))
    y = y_offset + (radius_offset * Math.sin(angle.deg2rad))
    
    # Draw label
    @d.fill = @font_color
    @d.font = @font if @font
    @d.pointsize = scale_fontsize(@marker_font_size)
    @d.stroke = 'transparent'
    @d.font_weight = BoldWeight
    @d.gravity = CenterGravity
    @d.annotate_scaled( @base_image, 
                      0, 0,
                      x, y, 
                      amount, @scale)
  end

  def sums_for_pie
    total_sum = 0.0
    @data.collect {|data_row| total_sum += data_row[DATA_VALUES_INDEX].first }
    total_sum
  end

end

class Float
  # Used for degree => radian conversions
  def deg2rad
    self * (Math::PI/180.0)
  end
end


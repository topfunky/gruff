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
  # Can be used to make the pie start cutting slices at the top (-90.0)
  # or at another angle. Default is 0.0, which starts at 3 o'clock.
  attr_accessor :zero_degree
  # Do not show labels for slices that are less than this percent. Use 0 to always show all labels.
  # Defaults to 0
  attr_accessor :hide_labels_less_than
  # Affect the distance between the percentages and the pie chart
  # Defaults to 0.15
  attr_accessor :text_offset_percentage
  # Callback to change label text
  attr_accessor :label_formatter

  def initialize_ivars
    super
    @zero_degree = 0.0
    @hide_labels_less_than = 0.0
    @text_offset_percentage = 1.0
    @label_formatter = nil
  end

  def draw
    @hide_line_markers = true

    super

    return unless @has_data

    diameter = @graph_height
    radius = ([@graph_width, @graph_height].min / 2.0) * 0.8
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

        label_val = ((data_row[DATA_VALUES_INDEX].first / total_sum) * 100.0).round
        unless label_val < @hide_labels_less_than
          # RMagick must use sprintf with the string and % has special significance.
          if @label_formatter
             label_string = @label_formatter.call(data_row)
          else
             label_string = label_val.to_s + '%'
             end
          @d = draw_label(center_x,center_y, half_angle,
                          radius,
                          label_string)
        end

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
  def draw_label(center_x, center_y, angle, radius, label_text)
    # TODO Don't use so many hard-coded numbers
    r_offset = radius/10.0  # The distance out from the center of the pie to get point
    x_offset = center_x  # + 15.0 # The label points need to be tweaked slightly
    y_offset = center_y  # This one doesn't though
    radius_offset = (radius + r_offset)
    ellipse_factor = radius_offset * @text_offset_percentage
    arad = angle.deg2rad
    x = x_offset + ((radius_offset + ellipse_factor) * Math.cos(arad))
    y = y_offset + (1.2 * radius_offset * Math.sin(arad))

    # Draw label
    @d.fill = @font_color
    @d.font = @font if @font
    @d.pointsize = scale_fontsize(@marker_font_size)
    @d.stroke = 'transparent'
    @d.font_weight = BoldWeight
    @d.gravity = CenterGravity
    @d.annotate_scaled( @base_image, 0, 0, x, y, label_text, @scale)
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


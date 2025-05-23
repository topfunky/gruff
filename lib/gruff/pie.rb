# frozen_string_literal: true

#
# Here's how to make a Gruff::Pie.
#
#   g = Gruff::Pie.new
#   g.title = "Visual Pie Graph Test"
#   g.data 'Fries', 20
#   g.data 'Hamburgers', 50
#   g.write("pie_keynote.png")
#
# To control where the pie chart starts creating slices, use {#start_degree=}.
#
class Gruff::Pie < Gruff::Base
  DEFAULT_TEXT_OFFSET_PERCENTAGE = 0.1

  # Can be used to make the pie start cutting slices at the top (-90.0)
  # or at another angle. Default is +-90.0+, which starts at 3 o'clock.
  attr_writer :start_degree

  # Set the number output format lambda.
  attr_writer :label_formatting

  # Do not show labels for slices that are less than this percent. Use 0 to always show all labels.
  # Defaults to +0+.
  attr_writer :hide_labels_less_than

  # Affect the distance between the percentages and the pie chart.
  # Defaults to +0.1+.
  attr_writer :text_offset_percentage

  ## Use values instead of percentages.
  attr_writer :show_values_as_labels

  # Set to +true+ if you want the data sets sorted with largest avg values drawn
  # first. Default is +true+.
  attr_writer :sort

  # Can be used to make the pie start cutting slices at the top (-90.0)
  # or at another angle. Default is +-90.0+, which starts at 3 o'clock.
  # @deprecated Please use {#start_degree=} instead.
  def zero_degree=(value)
    warn '#zero_degree= is deprecated. Please use `start_degree` attribute instead'
    @start_degree = value
  end

private

  def initialize_attributes
    super
    @start_degree = -90.0
    @hide_labels_less_than = 0.0
    @text_offset_percentage = DEFAULT_TEXT_OFFSET_PERCENTAGE
    @show_values_as_labels = false
    @marker_font.bold = true
    @sort = true

    @hide_line_markers = true
    @hide_line_markers.freeze

    @label_formatting = ->(value, percentage) { @show_values_as_labels ? value.to_s : "#{percentage}%" }
  end

  def setup_drawing
    @center_labels_over_point = false
    super
  end

  def draw_graph
    slices.each do |slice|
      if slice.value > 0
        Gruff::Renderer::Ellipse.new(renderer, color: slice.color, width: radius)
                                .render(center_x, center_y, radius / 2.0, radius / 2.0, chart_degrees, chart_degrees + slice.degrees + 0.5)
        process_label_for slice
        update_chart_degrees_with slice.degrees
      end
    end
  end

  def slices
    @slices ||= begin
      slices = store.data.map { |data| Gruff::Pie::PieSlice.new(data.label, data.points.first, data.color) }

      slices.sort_by(&:value) if @sort

      total = slices.sum(&:value).to_f
      slices.each { |slice| slice.total = total }
    end
  end

  # General Helper Methods

  def update_chart_degrees_with(degrees)
    @chart_degrees = chart_degrees + degrees
  end

  # Spatial Value-Related Methods

  def chart_degrees
    @chart_degrees ||= @start_degree
  end

  attr_reader :graph_height
  attr_reader :graph_width

  def half_width
    graph_width / 2.0
  end

  def half_height
    graph_height / 2.0
  end

  def radius
    @radius ||= ([graph_width, graph_height].min / 2.0) * 0.8
  end

  def center_x
    @center_x ||= @graph_left + half_width
  end

  def center_y
    @center_y ||= @graph_top + half_height - 10
  end

  def distance_from_center
    20.0
  end

  def radius_offset
    radius + (radius * @text_offset_percentage) + distance_from_center
  end

  def ellipse_factor
    radius_offset * @text_offset_percentage
  end

  # Label-Related Methods

  def process_label_for(slice)
    if slice.percentage >= @hide_labels_less_than
      x, y = label_coordinates_for slice
      label = @label_formatting.call(slice.value, slice.percentage)
      draw_label_at(1.0, 1.0, x, y, label, gravity: Magick::CenterGravity)
    end
  end

  def label_coordinates_for(slice)
    angle = chart_degrees + (slice.degrees / 2.0)

    [x_label_coordinate(angle), y_label_coordinate(angle)]
  end

  def x_label_coordinate(angle)
    center_x + ((radius_offset + ellipse_factor) * Math.cos(deg2rad(angle)))
  end

  def y_label_coordinate(angle)
    center_y + (radius_offset * Math.sin(deg2rad(angle)))
  end

  # Helper Classes
  #
  # @private
  class PieSlice
    attr_accessor :label
    attr_accessor :value
    attr_accessor :color
    attr_accessor :total

    def initialize(label, value, color)
      @label = label
      @value = value || 0
      @color = color
    end

    def percentage
      (size * 100.0).round
    end

    def degrees
      size * 360.0
    end

  private

    def size
      value / total
    end
  end
end

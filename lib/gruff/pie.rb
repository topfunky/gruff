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
# To control where the pie chart starts creating slices, use {#zero_degree=}.
#
class Gruff::Pie < Gruff::Base
  DEFAULT_TEXT_OFFSET_PERCENTAGE = 0.15

  # Can be used to make the pie start cutting slices at the top (-90.0)
  # or at another angle. Default is +0.0+, which starts at 3 o'clock.
  attr_writer :zero_degree

  # Do not show labels for slices that are less than this percent. Use 0 to always show all labels.
  # Defaults to +0+.
  attr_writer :hide_labels_less_than

  # Affect the distance between the percentages and the pie chart.
  # Defaults to +0.15+.
  attr_writer :text_offset_percentage

  ## Use values instead of percentages.
  attr_writer :show_values_as_labels

  def initialize_store
    @store = Gruff::Store.new(Gruff::Store::CustomData)
  end
  private :initialize_store

  def initialize_ivars
    super
    @zero_degree = 0.0
    @hide_labels_less_than = 0.0
    @text_offset_percentage = DEFAULT_TEXT_OFFSET_PERCENTAGE
    @show_values_as_labels = false
  end
  private :initialize_ivars

  def options
    {
      zero_degree: @zero_degree,
      hide_labels_less_than: @hide_labels_less_than,
      text_offset_percentage: @text_offset_percentage,
      show_values_as_labels: @show_values_as_labels
    }
  end

  def draw
    hide_line_markers

    super

    return unless data_given?

    slices.each do |slice|
      if slice.value > 0
        Gruff::Renderer::Ellipse.new(color: slice.color, width: radius)
                                .render(center_x, center_y, radius / 2.0, radius / 2.0, chart_degrees, chart_degrees + slice.degrees + 0.5)
        process_label_for slice
        update_chart_degrees_with slice.degrees
      end
    end

    Gruff::Renderer.finish
  end

private

  def slices
    @slices ||= begin
      slices = store.data.map { |data| slice_class.new(data, options) }

      slices.sort_by(&:value) if @sort

      total = slices.map(&:value).sum.to_f
      slices.each { |slice| slice.total = total }
    end
  end

  # General Helper Methods

  def hide_line_markers
    @hide_line_markers = true
  end

  def update_chart_degrees_with(degrees)
    @chart_degrees = chart_degrees + degrees
  end

  def slice_class
    PieSlice
  end

  # Spatial Value-Related Methods

  def chart_degrees
    @chart_degrees ||= @zero_degree
  end

  attr_reader :graph_height

  attr_reader :graph_width

  def diameter
    graph_height
  end

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

      draw_label(x, y, slice.label)
    end
  end

  def label_coordinates_for(slice)
    angle = chart_degrees + slice.degrees / 2

    [x_label_coordinate(angle), y_label_coordinate(angle)]
  end

  def x_label_coordinate(angle)
    center_x + ((radius_offset + ellipse_factor) * Math.cos(deg2rad(angle)))
  end

  def y_label_coordinate(angle)
    center_y + (radius_offset * Math.sin(deg2rad(angle)))
  end

  # Drawing-Related Methods

  def draw_label(x, y, value)
    text_renderer = Gruff::Renderer::Text.new(value, font: @font, size: @marker_font_size, color: @font_color, weight: Magick::BoldWeight)
    text_renderer.add_to_render_queue(0, 0, x, y, Magick::CenterGravity)
  end

  # Helper Classes
  #
  # @private
  class PieSlice < Struct.new(:data_array, :options)
    attr_accessor :total

    def name
      data_array[0]
    end

    def value
      data_array[1].first
    end

    def color
      data_array[2]
    end

    def size
      @size ||= value / total
    end

    def percentage
      @percentage ||= (size * 100.0).round
    end

    def degrees
      @degrees ||= size * 360.0
    end

    def label
      options[:show_values_as_labels] ? value.to_s : "#{percentage}%"
    end
  end
end

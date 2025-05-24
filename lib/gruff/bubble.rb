# frozen_string_literal: true

# rbs_inline: enabled

#
# Here's how to set up a Gruff::Bubble.
#
#   g = Gruff::Bubble.new
#   g.title = 'Bubble plot'
#   g.write('bubble.png')
#
class Gruff::Bubble < Gruff::Scatter
  # Specifies the filling opacity in area graph. Default is +0.6+.
  attr_writer :fill_opacity #: Float | Integer

  # Specifies the stroke width in line. Default is +1.0+.
  attr_writer :stroke_width #: Float | Integer

  # The first parameter is the name of the dataset.  The next two are the
  # x and y axis data points contain in their own array in that respective
  # order. The 4th argument represents sizes of points.
  # The final parameter is the color.
  #
  # Can be called multiple times with different datasets for a multi-valued
  # graph.
  #
  # If the color argument is nil, the next color from the default theme will
  # be used.
  #
  # @note If you want to use a preset theme, you must set it before calling {#data}.
  #
  # @param name [String, Symbol] containing the name of the dataset.
  # @param x_data_points [Array] An Array of x-axis data points.
  # @param y_data_points [Array] An Array of y-axis data points.
  # @param point_sizes   [Array] An Array of sizes for points.
  # @param color [String] The hex string for the color of the dataset. Defaults to nil.
  #
  # @raise [ArgumentError] Data points contain nil values.
  #   This error will get raised if either the x or y axis data points array
  #   contains a +nil+ value.  The graph will not make an assumption
  #   as how to graph +nil+.
  # @raise [ArgumentError] +x_data_points+ is empty.
  #   This error is raised when the array for the x-axis points are empty
  # @raise [ArgumentError] +y_data_points+ is empty.
  #   This error is raised when the array for the y-axis points are empty.
  # @raise [ArgumentError] +point_sizes+ is empty.
  #   This error is raised when the array for the point_sizes are empty
  # @raise [ArgumentError] +x_data_points.length != y_data_points.length+.
  #   Error means that the x and y axis point arrays do not match in length.
  # @raise [ArgumentError] +x_data_points.length != point_sizes.length+.
  #   Error means that the x and point_sizes arrays do not match in length.
  #
  # @example
  #   g = Gruff::Bubble.new
  #   g.title = "Bubble Graph"
  #   g.data :A, [-1, 19, -4, -23], [-35, 21, 23, -4], [4.5, 1.0, 2.1, 0.9]
  #
  # @rbs name: String | Symbol
  # @rbs x_data_points: Array[nil | Float | Integer] | nil
  # @rbs y_data_points: Array[nil | Float | Integer] | nil
  # @rbs point_sizes: Array[nil | Float | Integer] | nil
  # @rbs color: String
  def data(name, x_data_points = [], y_data_points = [], point_sizes = [], color = nil)
    # make sure it's an array
    x_data_points = Array(x_data_points)
    y_data_points = Array(y_data_points)
    point_sizes   = Array(point_sizes)

    raise ArgumentError, 'Data Points contain nil Value!' if x_data_points.include?(nil) || y_data_points.include?(nil)
    raise ArgumentError, 'x_data_points is empty!' if x_data_points.empty?
    raise ArgumentError, 'y_data_points is empty!' if y_data_points.empty?
    raise ArgumentError, 'point_sizes is empty!'   if point_sizes.empty?
    raise ArgumentError, 'x_data_points.length != y_data_points.length!' if x_data_points.length != y_data_points.length
    raise ArgumentError, 'x_data_points.length != point_sizes.length!'   if x_data_points.length != point_sizes.length

    store.add(name, x_data_points, y_data_points, point_sizes, color)
  end

private

  def initialize_store
    @store = Gruff::Store.new(Gruff::Store::XYPointsizeData)
  end

  def initialize_attributes
    super

    @fill_opacity = 0.6
    @stroke_width = 1.0
  end

  def draw_graph
    store.norm_data.each do |data_row|
      data_row.coordinate_and_pointsizes.each do |x_value, y_value, point_size|
        next if y_value.nil? || x_value.nil?

        new_x = @graph_left + (x_value * @graph_width)
        new_y = @graph_bottom - (y_value * @graph_height)
        diameter = @graph_width / (@marker_count * x_increment) * point_size.to_f

        Gruff::Renderer::Circle.new(renderer, color: data_row.color, width: @stroke_width, opacity: @fill_opacity)
                               .render(new_x, new_y, new_x - (diameter / 2.0), new_y)
      end
    end
  end
end

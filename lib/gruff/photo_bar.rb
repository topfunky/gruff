require File.dirname(__FILE__) + '/base'

class Gruff::PhotoBar < Gruff::Bar

# TODO
#
# define base and cap in yml
# allow for image directory to be located elsewhere
# more exact measurements for bar heights (go all the way to the bottom of the graph)
# option to tile images instead of use a single image
# drop base label a few px lower so photo bar graphs can have a base dropping over the lower marker line

  def initialize(size=800, theme='plastik')
    super(size)
    @theme = theme
    init_photo_bar_graphics()
  end

  def draw_bars
    @d.gravity = NorthWestGravity
    @norm_data.each_with_index do |data_row, row_index|
      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
        left = left(row_index, point_index)
        right = right(left)
        bottom = bottom(data_point)
        top = top(data_point)

        top, bottom = bottom, top if top < bottom
        column_height = top - bottom

        bar_image = @color_list[data_row[DATA_COLOR_INDEX]].resize(@bar_width, column_height)
        # See also
        # Draw#composite....with bar graph image OverCompositeOp
        # Draw.pattern # define an image to tile as the filling of a draw object
        @d = @d.composite(left, bottom, @bar_width, column_height, bar_image)
      end
    end

    @d.draw(@base_image)
  end

protected

  # Sets up colors with a list of images that will be used.
  def init_photo_bar_graphics
    @color_list = {}
    theme_dir = File.dirname(__FILE__) + '/../../assets/' + @theme
    Dir.open(theme_dir).each do |file|
      match = /(.*)\.png$/.match(file)
      next unless match
      @color_list[match[1]] = Image.read("#{theme_dir}/#{file}").first
    end
  end

end


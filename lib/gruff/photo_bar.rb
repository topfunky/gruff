# frozen_string_literal: true

require 'gruff/base'

# EXPERIMENTAL!
#
# Doesn't work yet.
#
class Gruff::PhotoBar < Gruff::Base
# TODO
#
# define base and cap in yml
# allow for image directory to be located elsewhere
# more exact measurements for bar heights (go all the way to the bottom of the graph)
# option to tile images instead of use a single image
# drop base label a few px lower so photo bar graphs can have a base dropping over the lower marker line
#

  # The name of a pre-packaged photo-based theme.
  attr_reader :theme

#   def initialize(target_width=800)
#     super
#     init_photo_bar_graphics()
#   end

  def draw
    super
    return unless data_given?

    return # TODO: Remove for further development

    init_photo_bar_graphics

    #Draw#define_clip_path()
    #Draw#clip_path(pathname)
    #Draw#composite....with bar graph image OverCompositeOp
    #
    # See also
    #
    # Draw.pattern # define an image to tile as the filling of a draw object
    #

    # Setup spacing.
    #
    # Columns sit side-by-side.
    spacing_factor = 0.9
    bar_width = store.norm_data[0].color.columns

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        data_point = 0 if data_point.nil?
        # Use incremented x and scaled y
        left_x = @graph_left + (bar_width * (row_index + point_index + ((store.length - 1) * point_index)))
        left_y = @graph_top + (@graph_height - data_point * @graph_height) + 1
        right_x = left_x + bar_width * spacing_factor
        right_y = @graph_top + @graph_height - 1

        bar_image_width = data_row.color.columns
        bar_image_height = right_y.to_f - left_y.to_f

        # Crop to scale for data
        bar_image = data_row.color.crop(0, 0, bar_image_width, bar_image_height)

        @d.gravity = Magick::NorthWestGravity
        @d.composite(left_x, left_y, bar_image_width, bar_image_height, bar_image)

        # Calculate center based on bar_width and current row
        label_center = @graph_left + (store.length * bar_width * point_index) + (store.length * bar_width / 2.0)
        draw_label(label_center, point_index)
      end
    end

    Gruff::Renderer.finish
  end

  # Return the chosen theme or the default
  def theme
    @theme || 'plastik'
  end

protected

  # Sets up colors with a list of images that will be used.
  # Images should be 340px tall
  def init_photo_bar_graphics
    color_list = []
    theme_dir = File.dirname(__FILE__) + '/../../assets/' + theme

    Dir.open(theme_dir).each do |file|
      next unless /\.png$/.match(file)

      color_list << Magick::Image.read("#{theme_dir}/#{file}").first
    end
    @colors = color_list
  end
end

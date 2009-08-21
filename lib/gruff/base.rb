require 'rubygems'
require 'RMagick'

require File.dirname(__FILE__) + '/deprecated'

##
# = Gruff. Graphs.
#
# Author:: Geoffrey Grosenbach boss@topfunky.com
#
# Originally Created:: October 23, 2005
#
# Extra thanks to Tim Hunter for writing RMagick, and also contributions by
# Jarkko Laine, Mike Perham, Andreas Schwarz, Alun Eyre, Guillaume Theoret,
# David Stokar, Paul Rogers, Dave Woodward, Frank Oxener, Kevin Clark, Cies
# Breijs, Richard Cowin, and a cast of thousands.
#
# See Gruff::Base#theme= for setting themes.

module Gruff

  # This is the version of Gruff you are using.
  VERSION = '0.3.6'

  class Base

    include Magick
    include Deprecated

    # Draw extra lines showing where the margins and text centers are
    DEBUG = false

    # Used for navigating the array of data to plot
    DATA_LABEL_INDEX = 0
    DATA_VALUES_INDEX = 1
    DATA_COLOR_INDEX = 2

    # Space around text elements. Mostly used for vertical spacing
    LEGEND_MARGIN = TITLE_MARGIN = 20.0
    LABEL_MARGIN = 10.0
    DEFAULT_MARGIN = 20.0

    DEFAULT_TARGET_WIDTH = 800
    
    THOUSAND_SEPARATOR = ','

    # Blank space above the graph
    attr_accessor :top_margin

    # Blank space below the graph
    attr_accessor :bottom_margin

    # Blank space to the right of the graph
    attr_accessor :right_margin

    # Blank space to the left of the graph
    attr_accessor :left_margin
    
    # Blank space below the title
    attr_accessor :title_margin
    
    # Blank space below the legend
    attr_accessor :legend_margin

    # A hash of names for the individual columns, where the key is the array
    # index for the column this label represents.
    #
    # Not all columns need to be named.
    #
    # Example: 0 => 2005, 3 => 2006, 5 => 2007, 7 => 2008
    attr_accessor :labels

    # Used internally for spacing.
    #
    # By default, labels are centered over the point they represent.
    attr_accessor :center_labels_over_point

    # Used internally for horizontal graph types.
    attr_accessor :has_left_labels

    # A label for the bottom of the graph
    attr_accessor :x_axis_label

    # A label for the left side of the graph
    attr_accessor :y_axis_label

    # attr_accessor :x_axis_increment

    # Manually set increment of the horizontal marking lines
    attr_accessor :y_axis_increment

    # Get or set the list of colors that will be used to draw the bars or lines.
    attr_accessor :colors

    # The large title of the graph displayed at the top
    attr_accessor :title

    # Font used for titles, labels, etc. Works best if you provide the full
    # path to the TTF font file.  RMagick must be built with the Freetype
    # libraries for this to work properly.
    #
    # Tries to find Bitstream Vera (Vera.ttf) in the location specified by
    # ENV['MAGICK_FONT_PATH']. Uses default RMagick font otherwise.
    #
    # The font= method below fulfills the role of the writer, so we only need
    # a reader here.
    attr_reader :font

    attr_accessor :font_color

    # Prevent drawing of line markers
    attr_accessor :hide_line_markers

    # Prevent drawing of the legend
    attr_accessor :hide_legend

    # Prevent drawing of the title
    attr_accessor :hide_title

    # Prevent drawing of line numbers
    attr_accessor :hide_line_numbers

    # Message shown when there is no data. Fits up to 20 characters. Defaults
    # to "No Data."
    attr_accessor :no_data_message

    # The font size of the large title at the top of the graph
    attr_accessor :title_font_size

    # Optionally set the size of the font. Based on an 800x600px graph.
    # Default is 20.
    #
    # Will be scaled down if graph is smaller than 800px wide.
    attr_accessor :legend_font_size

    # The font size of the labels around the graph
    attr_accessor :marker_font_size

    # The color of the auxiliary lines
    attr_accessor :marker_color

    # The number of horizontal lines shown for reference
    attr_accessor :marker_count

    # You can manually set a minimum value instead of having the values
    # guessed for you.
    #
    # Set it after you have given all your data to the graph object.
    attr_accessor :minimum_value

    # You can manually set a maximum value, such as a percentage-based graph
    # that always goes to 100.
    #
    # If you use this, you must set it after you have given all your data to
    # the graph object.
    attr_accessor :maximum_value

    # Set to false if you don't want the data to be sorted with largest avg
    # values at the back.
    attr_accessor :sort

    # Experimental
    attr_accessor :additional_line_values

    # Experimental
    attr_accessor :stacked

    # Optionally set the size of the colored box by each item in the legend.
    # Default is 20.0
    #
    # Will be scaled down if graph is smaller than 800px wide.
    attr_accessor :legend_box_size

    # If one numerical argument is given, the graph is drawn at 4/3 ratio
    # according to the given width (800 results in 800x600, 400 gives 400x300,
    # etc.).
    #
    # Or, send a geometry string for other ratios ('800x400', '400x225').
    #
    # Looks for Bitstream Vera as the default font. Expects an environment var
    # of MAGICK_FONT_PATH to be set. (Uses RMagick's default font otherwise.)
    def initialize(target_width=DEFAULT_TARGET_WIDTH)
      if not Numeric === target_width
        geometric_width, geometric_height = target_width.split('x')
        @columns = geometric_width.to_f
        @rows = geometric_height.to_f
      else
        @columns = target_width.to_f
        @rows = target_width.to_f * 0.75
      end

      initialize_ivars

      reset_themes
      theme_keynote
    end

    # Set instance variables for this object.
    #
    # Subclasses can override this, call super, then set values separately.
    #
    # This makes it possible to set defaults in a subclass but still allow
    # developers to change this values in their program.
    def initialize_ivars
      # Internal for calculations
      @raw_columns = 800.0
      @raw_rows = 800.0 * (@rows/@columns)
      @column_count = 0
      @marker_count = nil
      @maximum_value = @minimum_value = nil
      @has_data = false
      @data = Array.new
      @labels = Hash.new
      @labels_seen = Hash.new
      @sort = true
      @title = nil

      @scale = @columns / @raw_columns

      vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
      @font = File.exists?(vera_font_path) ? vera_font_path : nil

      @marker_font_size = 21.0
      @legend_font_size = 20.0
      @title_font_size = 36.0
      
      @top_margin = @bottom_margin = @left_margin = @right_margin = DEFAULT_MARGIN
      @legend_margin = LEGEND_MARGIN
      @title_margin = TITLE_MARGIN

      @legend_box_size = 20.0

      @no_data_message = "No Data"

      @hide_line_markers = @hide_legend = @hide_title = @hide_line_numbers = false
      @center_labels_over_point = true
      @has_left_labels = false

      @additional_line_values = []
      @additional_line_colors = []
      @theme_options = {}

      @x_axis_label = @y_axis_label = nil
      @y_axis_increment = nil
      @stacked = nil
      @norm_data = nil
    end

    # Sets the top, bottom, left and right margins to +margin+.
    def margins=(margin)
      @top_margin = @left_margin = @right_margin = @bottom_margin = margin
    end

    # Sets the font for graph text to the font at +font_path+.
    def font=(font_path)
      @font = font_path
      @d.font = @font
    end

    # Add a color to the list of available colors for lines.
    #
    # Example:
    #  add_color('#c0e9d3')
    def add_color(colorname)
      @colors << colorname
    end

    # Replace the entire color list with a new array of colors. Also
    # aliased as the colors= setter method.
    #
    # If you specify fewer colors than the number of datasets you intend
    # to draw, 'increment_color' will cycle through the array, reusing
    # colors as needed.
    #
    # Note that (as with the 'theme' method), you should set up your color
    # list before you send your data (via the 'data' method).  Calls to the
    # 'data' method made prior to this call will use whatever color scheme
    # was in place at the time data was called.
    #
    # Example:
    #  replace_colors ['#cc99cc', '#d9e043', '#34d8a2']
    def replace_colors(color_list=[])
      @colors = color_list
      @color_index = 0
    end

    # You can set a theme manually. Assign a hash to this method before you
    # send your data.
    #
    #  graph.theme = {
    #    :colors => %w(orange purple green white red),
    #    :marker_color => 'blue',
    #    :background_colors => %w(black grey)
    #  }
    #
    # :background_image => 'squirrel.png' is also possible.
    #
    # (Or hopefully something better looking than that.)
    #
    def theme=(options)
      reset_themes()

      defaults = {
        :colors => ['black', 'white'],
        :additional_line_colors => [],
        :marker_color => 'white',
        :font_color => 'black',
        :background_colors => nil,
        :background_image => nil
      }
      @theme_options = defaults.merge options

      @colors = @theme_options[:colors]
      @marker_color = @theme_options[:marker_color]
      @font_color = @theme_options[:font_color] || @marker_color
      @additional_line_colors = @theme_options[:additional_line_colors]

      render_background
    end

    # A color scheme similar to the popular presentation software.
    def theme_keynote
      # Colors
      @blue = '#6886B4'
      @yellow = '#FDD84E'
      @green = '#72AE6E'
      @red = '#D1695E'
      @purple = '#8A6EAF'
      @orange = '#EFAA43'
      @white = 'white'
      @colors = [@yellow, @blue, @green, @red, @purple, @orange, @white]

      self.theme = {
        :colors => @colors,
        :marker_color => 'white',
        :font_color => 'white',
        :background_colors => ['black', '#4a465a']
      }
    end

    # A color scheme plucked from the colors on the popular usability blog.
    def theme_37signals
      # Colors
      @green = '#339933'
      @purple = '#cc99cc'
      @blue = '#336699'
      @yellow = '#FFF804'
      @red = '#ff0000'
      @orange = '#cf5910'
      @black = 'black'
      @colors = [@yellow, @blue, @green, @red, @purple, @orange, @black]

      self.theme = {
        :colors => @colors,
        :marker_color => 'black',
        :font_color => 'black',
        :background_colors => ['#d1edf5', 'white']
      }
    end

    # A color scheme from the colors used on the 2005 Rails keynote
    # presentation at RubyConf.
    def theme_rails_keynote
      # Colors
      @green = '#00ff00'
      @grey = '#333333'
      @orange = '#ff5d00'
      @red = '#f61100'
      @white = 'white'
      @light_grey = '#999999'
      @black = 'black'
      @colors = [@green, @grey, @orange, @red, @white, @light_grey, @black]

      self.theme = {
        :colors => @colors,
        :marker_color => 'white',
        :font_color => 'white',
        :background_colors => ['#0083a3', '#0083a3']
      }
    end

    # A color scheme similar to that used on the popular podcast site.
    def theme_odeo
      # Colors
      @grey = '#202020'
      @white = 'white'
      @dark_pink = '#a21764'
      @green = '#8ab438'
      @light_grey = '#999999'
      @dark_blue = '#3a5b87'
      @black = 'black'
      @colors = [@grey, @white, @dark_blue, @dark_pink, @green, @light_grey, @black]

      self.theme = {
        :colors => @colors,
        :marker_color => 'white',
        :font_color => 'white',
        :background_colors => ['#ff47a4', '#ff1f81']
      }
    end

    # A pastel theme
    def theme_pastel
      # Colors
      @colors = [
                 '#a9dada', # blue
                 '#aedaa9', # green
                 '#daaea9', # peach
                 '#dadaa9', # yellow
                 '#a9a9da', # dk purple
                 '#daaeda', # purple
                 '#dadada' # grey
                ]

      self.theme = {
        :colors => @colors,
        :marker_color => '#aea9a9', # Grey
        :font_color => 'black',
        :background_colors => 'white'
      }
    end

    # A greyscale theme
    def theme_greyscale
      # Colors
      @colors = [
                 '#282828', #
                 '#383838', #
                 '#686868', #
                 '#989898', #
                 '#c8c8c8', #
                 '#e8e8e8', #
                ]

      self.theme = {
        :colors => @colors,
        :marker_color => '#aea9a9', # Grey
        :font_color => 'black',
        :background_colors => 'white'
      }
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
    # Example:
    #   data("Bart S.", [95, 45, 78, 89, 88, 76], '#ffcc00')
    def data(name, data_points=[], color=nil)
      data_points = Array(data_points) # make sure it's an array
      @data << [name, data_points, (color || increment_color)]
      # Set column count if this is larger than previous counts
      @column_count = (data_points.length > @column_count) ? data_points.length : @column_count

      # Pre-normalize
      data_points.each_with_index do |data_point, index|
        next if data_point.nil?

        # Setup max/min so spread starts at the low end of the data points
        if @maximum_value.nil? && @minimum_value.nil?
          @maximum_value = @minimum_value = data_point
        end

        # TODO Doesn't work with stacked bar graphs
        # Original: @maximum_value = larger_than_max?(data_point, index) ? max(data_point, index) : @maximum_value
        @maximum_value = larger_than_max?(data_point) ? data_point : @maximum_value
        @has_data = true if @maximum_value >= 0

        @minimum_value = less_than_min?(data_point) ? data_point : @minimum_value
        @has_data = true if @minimum_value < 0
      end
    end

    # Writes the graph to a file. Defaults to 'graph.png'
    #
    # Example:
    #   write('graphs/my_pretty_graph.png')
    def write(filename="graph.png")
      draw()
      @base_image.write(filename)
    end

    # Return the graph as a rendered binary blob.
    def to_blob(fileformat='PNG')
      draw()
      return @base_image.to_blob do
        self.format = fileformat
      end
    end



    protected

    # Overridden by subclasses to do the actual plotting of the graph.
    #
    # Subclasses should start by calling super() for this method.
    def draw
      make_stacked if @stacked
      setup_drawing

      debug {
        # Outer margin
        @d.rectangle( @left_margin, @top_margin,
                      @raw_columns - @right_margin, @raw_rows - @bottom_margin)
        # Graph area box
        @d.rectangle( @graph_left, @graph_top, @graph_right, @graph_bottom)
      }
    end

    # Calculates size of drawable area and draws the decorations.
    #
    # * line markers
    # * legend
    # * title
    def setup_drawing
      # Maybe should be done in one of the following functions for more granularity.
      unless @has_data
        draw_no_data()
        return
      end

      normalize()
      setup_graph_measurements()
      sort_norm_data() if @sort # Sort norm_data with avg largest values set first (for display)

      draw_legend()
      draw_line_markers()
      draw_axis_labels()
      draw_title
    end

    # Make copy of data with values scaled between 0-100
    def normalize(force=false)
      if @norm_data.nil? || force
        @norm_data = []
        return unless @has_data

        calculate_spread

        @data.each do |data_row|
          norm_data_points = []
          data_row[DATA_VALUES_INDEX].each do |data_point|
            if data_point.nil?
              norm_data_points << nil
            else
              norm_data_points << ((data_point.to_f - @minimum_value.to_f ) / @spread)
            end
          end
          @norm_data << [data_row[DATA_LABEL_INDEX], norm_data_points, data_row[DATA_COLOR_INDEX]]
        end
      end
    end

    def calculate_spread # :nodoc:
      @spread = @maximum_value.to_f - @minimum_value.to_f
      @spread = @spread > 0 ? @spread : 1
    end

    ##
    # Calculates size of drawable area, general font dimensions, etc.

    def setup_graph_measurements
      @marker_caps_height = @hide_line_markers ? 0 :
        calculate_caps_height(@marker_font_size)
      @title_caps_height = @hide_title ? 0 :
        calculate_caps_height(@title_font_size)
      @legend_caps_height = @hide_legend ? 0 :
        calculate_caps_height(@legend_font_size)

      if @hide_line_markers
        (@graph_left,
         @graph_right_margin,
         @graph_bottom_margin) = [@left_margin, @right_margin, @bottom_margin]
      else
        longest_left_label_width = 0
        if @has_left_labels
          longest_left_label_width =  calculate_width(@marker_font_size,
                                                      labels.values.inject('') { |value, memo| (value.to_s.length > memo.to_s.length) ? value : memo }) * 1.25
        else
          longest_left_label_width = calculate_width(@marker_font_size,
                                                     label(@maximum_value.to_f))
        end

        # Shift graph if left line numbers are hidden
        line_number_width = @hide_line_numbers && !@has_left_labels ?
        0.0 :
          (longest_left_label_width + LABEL_MARGIN * 2)

        @graph_left = @left_margin +
          line_number_width +
          (@y_axis_label.nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN * 2)

        # Make space for half the width of the rightmost column label.
        # Might be greater than the number of columns if between-style bar markers are used.
        last_label = @labels.keys.sort.last.to_i
        extra_room_for_long_label = (last_label >= (@column_count-1) && @center_labels_over_point) ?
        calculate_width(@marker_font_size, @labels[last_label]) / 2.0 :
          0
        @graph_right_margin = @right_margin + extra_room_for_long_label

        @graph_bottom_margin = @bottom_margin +
          @marker_caps_height + LABEL_MARGIN
      end

      @graph_right = @raw_columns - @graph_right_margin
      @graph_width = @raw_columns - @graph_left - @graph_right_margin

      # When @hide title, leave a title_margin space for aesthetics.
      # Same with @hide_legend
      @graph_top = @top_margin +
        (@hide_title  ? title_margin  : @title_caps_height  + title_margin ) +
        (@hide_legend ? legend_margin : @legend_caps_height + legend_margin)

      x_axis_label_height = @x_axis_label.nil? ? 0.0 :
        @marker_caps_height + LABEL_MARGIN
      @graph_bottom = @raw_rows - @graph_bottom_margin - x_axis_label_height
      @graph_height = @graph_bottom - @graph_top
    end

    # Draw the optional labels for the x axis and y axis.
    def draw_axis_labels
      unless @x_axis_label.nil?
        # X Axis
        # Centered vertically and horizontally by setting the
        # height to 1.0 and the width to the width of the graph.
        x_axis_label_y_coordinate = @graph_bottom + LABEL_MARGIN * 2 + @marker_caps_height

        # TODO Center between graph area
        @d.fill = @font_color
        @d.font = @font if @font
        @d.stroke('transparent')
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = NorthGravity
        @d = @d.annotate_scaled( @base_image,
                                 @raw_columns, 1.0,
                                 0.0, x_axis_label_y_coordinate,
                                 @x_axis_label, @scale)
        debug { @d.line 0.0, x_axis_label_y_coordinate, @raw_columns, x_axis_label_y_coordinate }
      end

      unless @y_axis_label.nil?
        # Y Axis, rotated vertically
        @d.rotation = 90.0
        @d.gravity = CenterGravity
        @d = @d.annotate_scaled( @base_image,
                                 1.0, @raw_rows,
                                 @left_margin + @marker_caps_height / 2.0, 0.0,
                                 @y_axis_label, @scale)
        @d.rotation = -90.0
      end
    end

    # Draws horizontal background lines and labels
    def draw_line_markers
      return if @hide_line_markers

      @d = @d.stroke_antialias false

      if @y_axis_increment.nil?
        # Try to use a number of horizontal lines that will come out even.
        #
        # TODO Do the same for larger numbers...100, 75, 50, 25
        if @marker_count.nil?
          (3..7).each do |lines|
            if @spread % lines == 0.0
              @marker_count = lines
              break
            end
          end
          @marker_count ||= 4
        end
        @increment = (@spread > 0) ? significant(@spread / @marker_count) : 1
      else
        # TODO Make this work for negative values
        @maximum_value = [@maximum_value.ceil, @y_axis_increment].max
        @minimum_value = @minimum_value.floor
        calculate_spread
        normalize(true)

        @marker_count = (@spread / @y_axis_increment).to_i
        @increment = @y_axis_increment
      end
      @increment_scaled = @graph_height.to_f / (@spread / @increment)

      # Draw horizontal line markers and annotate with numbers
      (0..@marker_count).each do |index|
        y = @graph_top + @graph_height - index.to_f * @increment_scaled

        @d = @d.fill(@marker_color)
        @d = @d.line(@graph_left, y, @graph_right, y)

        marker_label = index * @increment + @minimum_value.to_f

        unless @hide_line_numbers
          @d.fill = @font_color
          @d.font = @font if @font
          @d.stroke('transparent')
          @d.pointsize = scale_fontsize(@marker_font_size)
          @d.gravity = EastGravity

          # Vertically center with 1.0 for the height
          @d = @d.annotate_scaled( @base_image,
                                   @graph_left - LABEL_MARGIN, 1.0,
                                   0.0, y,
                                   label(marker_label), @scale)
        end
      end

      # # Submitted by a contibutor...the utility escapes me
      # i = 0
      # @additional_line_values.each do |value|
      #   @increment_scaled = @graph_height.to_f / (@maximum_value.to_f / value)
      #
      #   y = @graph_top + @graph_height - @increment_scaled
      #
      #   @d = @d.stroke(@additional_line_colors[i])
      #   @d = @d.line(@graph_left, y, @graph_right, y)
      #
      #
      #   @d.fill = @additional_line_colors[i]
      #   @d.font = @font if @font
      #   @d.stroke('transparent')
      #   @d.pointsize = scale_fontsize(@marker_font_size)
      #   @d.gravity = EastGravity
      #   @d = @d.annotate_scaled( @base_image,
      #                     100, 20,
      #                     -10, y - (@marker_font_size/2.0),
      #                     "", @scale)
      #   i += 1
      # end

      @d = @d.stroke_antialias true
    end

    ##
    # Return the sum of values in an array.
    #
    # Duplicated to not conflict with active_support in Rails.

    def sum(arr)
      arr.inject(0) { |i, m| m + i }
    end

    ##
    # Return a calculation of center

    def center(size)
      (@raw_columns - size) / 2
    end

    ##
    # Draws a legend with the names of the datasets matched
    # to the colors used to draw them.

    def draw_legend
      return if @hide_legend

      @legend_labels = @data.collect {|item| item[DATA_LABEL_INDEX] }

      legend_square_width = @legend_box_size # small square with color of this item

      # May fix legend drawing problem at small sizes
      @d.font = @font if @font
      @d.pointsize = @legend_font_size

      label_widths = [[]] # Used to calculate line wrap
      @legend_labels.each do |label|
        metrics = @d.get_type_metrics(@base_image, label.to_s)
        label_width = metrics.width + legend_square_width * 2.7
        label_widths.last.push label_width

        if sum(label_widths.last) > (@raw_columns * 0.9)
          label_widths.push [label_widths.last.pop]
        end
      end

      current_x_offset = center(sum(label_widths.first))
      current_y_offset =  @hide_title ?
      @top_margin + title_margin :
        @top_margin + title_margin + @title_caps_height

      @legend_labels.each_with_index do |legend_label, index|

        # Draw label
        @d.fill = @font_color
        @d.font = @font if @font
        @d.pointsize = scale_fontsize(@legend_font_size)
        @d.stroke('transparent')
        @d.font_weight = NormalWeight
        @d.gravity = WestGravity
        @d = @d.annotate_scaled( @base_image,
                                 @raw_columns, 1.0,
                                 current_x_offset + (legend_square_width * 1.7), current_y_offset,
                                 legend_label.to_s, @scale)

        # Now draw box with color of this dataset
        @d = @d.stroke('transparent')
        @d = @d.fill @data[index][DATA_COLOR_INDEX]
        @d = @d.rectangle(current_x_offset,
                          current_y_offset - legend_square_width / 2.0,
                          current_x_offset + legend_square_width,
                          current_y_offset + legend_square_width / 2.0)

        @d.pointsize = @legend_font_size
        metrics = @d.get_type_metrics(@base_image, legend_label.to_s)
        current_string_offset = metrics.width + (legend_square_width * 2.7)

        # Handle wrapping
        label_widths.first.shift
        if label_widths.first.empty?
          debug { @d.line 0.0, current_y_offset, @raw_columns, current_y_offset }

          label_widths.shift
          current_x_offset = center(sum(label_widths.first)) unless label_widths.empty?
          line_height = [@legend_caps_height, legend_square_width].max + legend_margin
          if label_widths.length > 0
            # Wrap to next line and shrink available graph dimensions
            current_y_offset += line_height
            @graph_top += line_height
            @graph_height = @graph_bottom - @graph_top
          end
        else
          current_x_offset += current_string_offset
        end
      end
      @color_index = 0
    end

    # Draws a title on the graph.
    def draw_title
      return if (@hide_title || @title.nil?)

      @d.fill = @font_color
      @d.font = @font if @font
      @d.stroke('transparent')
      @d.pointsize = scale_fontsize(@title_font_size)
      @d.font_weight = BoldWeight
      @d.gravity = NorthGravity
      @d = @d.annotate_scaled( @base_image,
                               @raw_columns, 1.0,
                               0, @top_margin,
                               @title, @scale)
    end

    # Draws column labels below graph, centered over x_offset
    #--
    # TODO Allow WestGravity as an option
    def draw_label(x_offset, index)
      return if @hide_line_markers

      if !@labels[index].nil? && @labels_seen[index].nil?
        y_offset = @graph_bottom + LABEL_MARGIN

        @d.fill = @font_color
        @d.font = @font if @font
        @d.stroke('transparent')
        @d.font_weight = NormalWeight
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = NorthGravity
        @d = @d.annotate_scaled(@base_image,
                                1.0, 1.0,
                                x_offset, y_offset,
                                @labels[index], @scale)
        @labels_seen[index] = 1
        debug { @d.line 0.0, y_offset, @raw_columns, y_offset }
      end
    end

    # Shows an error message because you have no data.
    def draw_no_data
      @d.fill = @font_color
      @d.font = @font if @font
      @d.stroke('transparent')
      @d.font_weight = NormalWeight
      @d.pointsize = scale_fontsize(80)
      @d.gravity = CenterGravity
      @d = @d.annotate_scaled( @base_image,
                               @raw_columns, @raw_rows/2.0,
                               0, 10,
                               @no_data_message, @scale)
    end

    # Finds the best background to render based on the provided theme options.
    #
    # Creates a @base_image to draw on.
    def render_background
      case @theme_options[:background_colors]
      when Array
        @base_image = render_gradiated_background(*@theme_options[:background_colors])
      when String
        @base_image = render_solid_background(@theme_options[:background_colors])
      else
        @base_image = render_image_background(*@theme_options[:background_image])
      end
    end

    # Make a new image at the current size with a solid +color+.
    def render_solid_background(color)
      Image.new(@columns, @rows) {
        self.background_color = color
      }
    end

    # Use with a theme definition method to draw a gradiated background.
    def render_gradiated_background(top_color, bottom_color)
      Image.new(@columns, @rows,
                GradientFill.new(0, 0, 100, 0, top_color, bottom_color))
    end

    # Use with a theme to use an image (800x600 original) background.
    def render_image_background(image_path)
      image = Image.read(image_path)
      if @scale != 1.0
        image[0].resize!(@scale) # TODO Resize with new scale (crop if necessary for wide graph)
      end
      image[0]
    end

    # Use with a theme to make a transparent background
    def render_transparent_background
      Image.new(@columns, @rows) do
        self.background_color = 'transparent'
      end
    end

    # Resets everything to defaults (except data).
    def reset_themes
      @color_index = 0
      @labels_seen = {}
      @theme_options = {}

      @d = Draw.new
      # Scale down from 800x600 used to calculate drawing.
      @d = @d.scale(@scale, @scale)
    end

    def scale(value) # :nodoc:
      value * @scale
    end

    # Return a comparable fontsize for the current graph.
    def scale_fontsize(value)
      new_fontsize = value * @scale
      # return new_fontsize < 10.0 ? 10.0 : new_fontsize
      return new_fontsize
    end

    def clip_value_if_greater_than(value, max_value) # :nodoc:
      (value > max_value) ? max_value : value
    end

    # Overridden by subclasses such as stacked bar.
    def larger_than_max?(data_point, index=0) # :nodoc:
      data_point > @maximum_value
    end

    def less_than_min?(data_point, index=0) # :nodoc:
      data_point < @minimum_value
    end

    # Overridden by subclasses that need it.
    def max(data_point, index) # :nodoc:
      data_point
    end

    # Overridden by subclasses that need it.
    def min(data_point, index) # :nodoc:
      data_point
    end

    def significant(inc) # :nodoc:
      return 1.0 if inc == 0 # Keep from going into infinite loop
      factor = 1.0
      while (inc < 10)
        inc *= 10
        factor /= 10
      end

      while (inc > 100)
        inc /= 10
        factor *= 10
      end

      res = inc.floor * factor
      if (res.to_i.to_f == res)
        res.to_i
      else
        res
      end
    end

    # Sort with largest overall summed value at front of array so it shows up
    # correctly in the drawn graph.
    def sort_norm_data
      @norm_data.sort! { |a,b| sums(b[DATA_VALUES_INDEX]) <=> sums(a[DATA_VALUES_INDEX]) }
    end

    def sums(data_set) # :nodoc:
      total_sum = 0
      data_set.collect {|num| total_sum += num.to_f }
      total_sum
    end

    # Used by StackedBar and child classes.
    #
    # May need to be moved to the StackedBar class.
    def get_maximum_by_stack
      # Get sum of each stack
      max_hash = {}
      @data.each do |data_set|
        data_set[DATA_VALUES_INDEX].each_with_index do |data_point, i|
          max_hash[i] = 0.0 unless max_hash[i]
          max_hash[i] += data_point.to_f
        end
      end

      # @maximum_value = 0
      max_hash.keys.each do |key|
        @maximum_value = max_hash[key] if max_hash[key] > @maximum_value
      end
      @minimum_value = 0
    end

    def make_stacked # :nodoc:
      stacked_values = Array.new(@column_count, 0)
      @data.each do |value_set|
        value_set[DATA_VALUES_INDEX].each_with_index do |value, index|
          stacked_values[index] += value
        end
        value_set[DATA_VALUES_INDEX] = stacked_values.dup
      end
    end

    private

    # Takes a block and draws it if DEBUG is true.
    #
    # Example:
    #   debug { @d.rectangle x1, y1, x2, y2 }
    def debug
      if DEBUG
        @d = @d.fill 'transparent'
        @d = @d.stroke 'turquoise'
        @d = yield
      end
    end

    # Returns the next color in your color list.
    def increment_color
      @color_index = (@color_index + 1) % @colors.length
      return @colors[@color_index - 1]
    end

    # Return a formatted string representing a number value that should be
    # printed as a label.
    def label(value)
      label = if (@spread.to_f % @marker_count.to_f == 0) || !@y_axis_increment.nil?
        value.to_i.to_s
      elsif @spread > 10.0
        sprintf("%0i", value)
      elsif @spread >= 3.0
        sprintf("%0.2f", value)
      else
        value.to_s
      end
      
      parts = label.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{THOUSAND_SEPARATOR}")
      parts.join('.')
    end

    # Returns the height of the capital letter 'X' for the current font and
    # size.
    #
    # Not scaled since it deals with dimensions that the regular scaling will
    # handle.
    def calculate_caps_height(font_size)
      @d.pointsize = font_size
      @d.get_type_metrics(@base_image, 'X').height
    end

    # Returns the width of a string at this pointsize.
    #
    # Not scaled since it deals with dimensions that the regular
    # scaling will handle.
    def calculate_width(font_size, text)
      @d.pointsize = font_size
      @d.get_type_metrics(@base_image, text.to_s).width
    end

  end # Gruff::Base

  class IncorrectNumberOfDatasetsException < StandardError; end

end # Gruff

module Magick

  class Draw

    # Additional method to scale annotation text since Draw.scale doesn't.
    def annotate_scaled(img, width, height, x, y, text, scale)
      scaled_width = (width * scale) >= 1 ? (width * scale) : 1
      scaled_height = (height * scale) >= 1 ? (height * scale) : 1

      self.annotate( img,
                     scaled_width, scaled_height,
                     x * scale, y * scale,
                     text)
    end

  end

end # Magick

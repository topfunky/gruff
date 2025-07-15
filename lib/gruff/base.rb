# frozen_string_literal: true

# rbs_inline: enabled

require 'bigdecimal'

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
# See {Gruff::Base#theme=} for setting themes.
module Gruff
  using String::GruffCommify

  # A common base class inherited from class of drawing a graph.
  class Base
    # Space around text elements. Mostly used for vertical spacing.
    LEGEND_MARGIN = 20.0
    TITLE_MARGIN = 20.0
    LABEL_MARGIN = 15.0
    DEFAULT_MARGIN = 20.0

    DEFAULT_TARGET_WIDTH = 800.0

    # Blank space between graph and labels. Default is +15+.
    attr_writer :label_margin #: Float | Integer

    # Blank space above the graph. Default is +20+.
    attr_writer :top_margin #: Float | Integer

    # Blank space below the graph. Default is +20+.
    attr_writer :bottom_margin #: Float | Integer

    # Blank space to the right of the graph. Default is +20+.
    attr_writer :right_margin #: Float | Integer

    # Blank space to the left of the graph. Default is +20+.
    attr_writer :left_margin #: Float | Integer

    # Blank space below the title. Default is +20+.
    attr_writer :title_margin #: Float | Integer

    # Blank space below the legend. Default is +20+.
    attr_writer :legend_margin #: Float | Integer

    # Truncates labels if longer than max specified.
    attr_writer :label_max_size #: Float | Integer

    # How truncated labels visually appear if they exceed {#label_max_size=}.
    #
    # - +:absolute+ - does not show trailing dots to indicate truncation. This is the default.
    # - +:trailing_dots+ - shows trailing dots to indicate truncation (note that {#label_max_size=}
    #   must be greater than 3).
    attr_writer :label_truncation_style #: (:absolute | :trailing_dots)

    # Set a label for the bottom of the graph.
    attr_writer :x_axis_label #: String

    # Set a label for the left side of the graph.
    attr_writer :y_axis_label #: String

    # Allow passing lambda to format labels for x axis.
    attr_writer :x_axis_label_format #: Proc

    # Allow passing lambda to format labels for y axis.
    attr_writer :y_axis_label_format #: Proc

    # Set increment of the vertical marking lines.
    attr_writer :x_axis_increment #: Float | Integer

    # Set increment of the horizontal marking lines.
    attr_writer :y_axis_increment #: Float | Integer

    # Get or set the list of colors that will be used to draw the bars or lines.
    attr_accessor :colors #: [String]

    # Prevent drawing of line markers. Default is +false+.
    attr_writer :hide_line_markers #: bool

    # Prevent drawing of the legend. Default is +false+.
    attr_writer :hide_legend #: bool

    # Prevent drawing of the title. Default is +false+.
    attr_writer :hide_title #: bool

    # Prevent drawing of line numbers. Default is +false+.
    attr_writer :hide_line_numbers #: bool

    # Set a message shown when there is no data. Fits up to 20 characters. Defaults
    # to +"No Data."+.
    attr_writer :no_data_message #: String

    # Set the color of the auxiliary lines.
    attr_writer :marker_color #: String

    # Set the shadow color of the auxiliary lines.
    attr_writer :marker_shadow_color #: String

    # Set the number of horizontal lines shown for reference.
    attr_writer :marker_count #: Float | Integer

    # Set to +true+ if you want the data sets sorted with largest avg values drawn
    # first. Default is +false+.
    attr_writer :sort #: bool

    # Set to +true+ if you want the data sets drawn with largest avg values drawn
    # first. This does not affect the legend. Default is +false+.
    attr_writer :sorted_drawing #: bool

    # Display the legend under the graph. Default is +false+.
    attr_writer :legend_at_bottom #: bool

    # Optionally set the size of the colored box by each item in the legend.
    # Default is +20.0+.
    #
    # Will be scaled down if graph is smaller than 800px wide.
    attr_writer :legend_box_size #: Float | Integer

    # If one numerical argument is given, the graph is drawn at 4/3 ratio
    # according to the given width (+800+ results in 800x600, +400+ gives 400x300,
    # etc.).
    #
    # Or, send a geometry string for other ratios ( +'800x400'+, +'400x225'+).
    #
    # @param target_width [Numeric, String] The graph image width.
    #
    # @rbs target_width: (String | Float | Integer)
    # @rbs return: void
    def initialize(target_width = DEFAULT_TARGET_WIDTH)
      if target_width.is_a?(String)
        @columns, @rows = target_width.split('x').map(&:to_f)
      else
        @columns = target_width.to_f
        @rows = target_width.to_f * 0.75
      end
      @columns.freeze
      @rows.freeze

      @has_left_labels = false
      @center_labels_over_point = true

      initialize_graph_scale
      initialize_attributes
      initialize_store

      self.theme = Themes::KEYNOTE
    end

    def initialize_graph_scale
      @raw_columns = DEFAULT_TARGET_WIDTH
      @raw_rows = DEFAULT_TARGET_WIDTH * (@rows / @columns)
      @raw_columns.freeze
      @raw_rows.freeze

      @scale = @columns / @raw_columns
      @scale.freeze
    end
    protected :initialize_graph_scale

    def initialize_store
      @store = Gruff::Store.new(Gruff::Store::BasicData)
    end
    protected :initialize_store

    # Initialize instance variable of attributes
    #
    # Subclasses can override this, call super, then set values separately.
    #
    # This makes it possible to set defaults in a subclass but still allow
    # developers to change this values in their program.
    def initialize_attributes
      @marker_count = nil
      @maximum_value = @minimum_value = nil
      @labels = {}
      @sort = false
      @sorted_drawing = false
      @title = nil

      @title_font = Gruff::Font.new(size: 36.0, bold: true)
      @marker_font = Gruff::Font.new(size: 21.0)
      @legend_font = Gruff::Font.new(size: 20.0)
      @no_data_font = Gruff::Font.new(size: 80.0)

      @label_margin = LABEL_MARGIN
      @top_margin = @bottom_margin = @left_margin = @right_margin = DEFAULT_MARGIN
      @legend_margin = LEGEND_MARGIN
      @title_margin = TITLE_MARGIN

      @legend_box_size = 20.0

      @no_data_message = 'No Data'

      @hide_line_markers = @hide_legend = @hide_title = @hide_line_numbers = @legend_at_bottom = false
      @label_max_size = 0
      @label_truncation_style = :absolute
      @label_rotation = 0

      @x_axis_increment = nil
      @x_axis_label = @y_axis_label = nil
      @y_axis_increment = nil

      @x_axis_label_format = nil
      @y_axis_label_format = nil
    end
    protected :initialize_attributes

    # A hash of names for the individual columns, where the key is the array
    # index for the column this label represents.
    # Not all columns need to be named with hash.
    #
    # Or, an array corresponding to the data values.
    #
    # @param labels [Hash, Array] the labels.
    # @rbs labels: (Hash[Integer, String] | [String | nil])
    #
    # @example
    #   g = Gruff::Bar.new
    #   g.labels = { 0 => '2005', 3 => '2006', 5 => '2007', 7 => '2008' }
    #
    #   g = Gruff::Bar.new
    #   g.labels = ['2005', nil, nil, '2006', nil, nil, '2007', nil, nil, '2008'] # same labels for columns
    #
    def labels=(labels)
      if labels.is_a?(Array)
        labels = labels.each_with_index.with_object({}) do |(label, index), hash|
          hash[index] = label
        end
      end

      @labels = labels
    end

    # Set a rotation for labels. You can use  Default is +0+.
    # You can use a rotation between +0.0+ and +45.0+, or between +0.0+ and +-45.0+.
    #
    # @param rotation [Numeric] the rotation.
    # @rbs rotation: Float | Integer
    def label_rotation=(rotation)
      raise ArgumentError, 'rotation must be between 0.0 and 45.0 or between 0.0 and -45.0' if rotation > 45.0 || rotation < -45.0

      @label_rotation = rotation.to_f
    end

    # Height of staggering between labels.
    # @deprecated
    def label_stagger_height=(_value)
      warn '#label_stagger_height= is deprecated. It is no longer effective.'
    end

    # Set the large title of the graph displayed at the top.
    # You can draw a multi-line title by putting a line break in the string
    # or by setting an array as argument.
    #
    # @param title [String, Array] the title.
    # @rbs title: (String | Array[String])
    #
    # @example
    #   g = Gruff::Bar.new
    #   g.title = "The graph title"
    #
    #   g = Gruff::Bar.new
    #   g.title = ['The first line of title', 'The second line of title']
    #
    def title=(title)
      if title.is_a?(Array)
        title = title.join("\n")
      end

      @title = title
    end

    # Sets the top, bottom, left and right margins to +margin+.
    #
    # @param margin [Numeric] The margin size.
    # @rbs margin: Float | Integer
    def margins=(margin)
      @top_margin = @left_margin = @right_margin = @bottom_margin = margin
    end

    # Sets the font for graph text to the font at +font_path+.
    #
    # @param font_path [String] The path to font.
    # @rbs font_path: String
    def font=(font_path)
      @title_font.path = font_path unless @title_font.path
      @marker_font.path = font_path
      @legend_font.path = font_path
      @no_data_font.path = font_path
    end

    # Same as {#font=} but for the title.
    #
    # @param font_path [String] The path to font.
    # @rbs font_path: String
    def title_font=(font_path)
      @title_font.path = font_path
    end

    # Set the font size of the large title at the top of the graph. Default is +36+.
    #
    # @param value [Numeric] title font size
    # @rbs value: Float | Integer
    def title_font_size=(value)
      @title_font.size = value
    end

    # The font size of the labels around the graph. Default is +21+.
    #
    # @param value [Numeric] marker font size
    # @rbs value: Float | Integer
    def marker_font_size=(value)
      @marker_font.size = value
    end

    # Optionally set the size of the font. Based on an 800x600px graph.
    # Default is +20+.
    #
    # Will be scaled down if the graph is smaller than 800px wide.
    #
    # @param value [Numeric] legend font size
    # @rbs value: Float | Integer
    def legend_font_size=(value)
      @legend_font.size = value
    end

    # Set the font size of the no data message. Default is +80+.
    #
    # @param value [Numeric] no data font size
    # @rbs value: Float | Integer
    def no_data_font_size=(value)
      @no_data_font.size = value
    end

    # Specifies whether to draw the title bolded or not. Default is +true+.
    #
    # @param value [Boolean] specifies whether to draw the title bolded or not.
    # @rbs value: bool
    def bold_title=(value)
      @title_font.bold = value
    end

    # Specifies the text color.
    #
    # @param value [String] color
    # @rbs value: String
    def font_color=(value)
      @title_font.color = value
      @marker_font.color = value
      @legend_font.color = value
      @no_data_font.color = value
    end

    # Add a color to the list of available colors for lines.
    #
    # @param colorname [String] The color.
    # @rbs colorname: String
    #
    # @example
    #   add_color('#c0e9d3')
    def add_color(colorname)
      @colors << colorname
    end

    # Replace the entire color list with a new array of colors. Also
    # aliased as the {#colors=} setter method.
    #
    # If you specify fewer colors than the number of datasets you intend
    # to draw, it will cycle through the array, reusing colors as needed.
    #
    # Note that (as with the {#theme=} method), you should set up your color
    # list before you send your data (via the {#data} method).  Calls to the
    # {#data} method made prior to this call will use whatever color scheme
    # was in place at the time data was called.
    #
    # @param color_list [Array] The array of colors.
    # @rbs color_list: Array[String]
    #
    # @example
    #   replace_colors ['#cc99cc', '#d9e043', '#34d8a2']
    def replace_colors(color_list = [])
      @colors = color_list
    end

    # Set whether to make background transparent.
    #
    # @param value [Boolean] Specify whether to make background transparent.
    # @rbs value: bool
    def transparent_background=(value)
      @renderer.transparent_background(@columns, @rows) if value
    end

    # You can set a theme manually. Assign a hash to this method before you
    # send your data.
    #
    #   g = Gruff::Bar.new
    #   g.theme = {
    #     colors: %w(orange purple green white red),
    #     marker_color: 'blue',
    #     background_colors: ['black', 'grey'],
    #     background_direction: :top_bottom
    #   }
    #
    # +background_colors+
    # - Array<String> format value - background has gradation. (ex. +background_colors: ['black', 'grey']+)
    # - String value - background has solid color. (ex. +background_colors: 'orange'+)
    # - nil - background has transparent. (ex. +background_colors: nil+)
    #
    # +background_image+:
    # - Specify the path to image file when it draw the image as background.
    #
    # +background_direction+ accepts one of following parameters.
    # - +:top_bottom+
    # - +:bottom_top+
    # - +:left_right+
    # - +:right_left+
    # - +:topleft_bottomright+
    # - +:topright_bottomleft+
    #
    # (Or hopefully something better looking than that.)
    #
    # @param options [Hash] The optional setting for theme
    # @rbs options: Hash[Symbol, untyped]
    def theme=(options)
      reset_themes

      defaults = {
        colors: %w[black white],
        marker_color: 'white',
        marker_shadow_color: nil,
        font_color: 'black',
        background_colors: 'gray',
        background_image: nil
      }
      @theme_options = defaults.merge options

      self.marker_color = @theme_options[:marker_color]
      self.font_color = @theme_options[:font_color] || @marker_color

      @colors = @theme_options[:colors].dup
      @marker_shadow_color = @theme_options[:marker_shadow_color]

      @renderer = Gruff::Renderer.new(@columns, @rows, @scale, @theme_options)
    end

    # Apply Apple's keynote theme.
    def theme_keynote
      self.theme = Themes::KEYNOTE
    end

    # Apply 37signals theme.
    def theme_37signals
      self.theme = Themes::THIRTYSEVEN_SIGNALS
    end

    # Apply Rails theme.
    def theme_rails_keynote
      self.theme = Themes::RAILS_KEYNOTE
    end

    # Apply Odeo theme.
    def theme_odeo
      self.theme = Themes::ODEO
    end

    # Apply pastel theme.
    def theme_pastel
      self.theme = Themes::PASTEL
    end

    # Apply greyscale theme.
    def theme_greyscale
      self.theme = Themes::GREYSCALE
    end

    # Input the data in the graph.
    #
    # Parameters are an array where the first element is the name of the dataset
    # and the value is an array of values to plot.
    #
    # Can be called multiple times with different datasets for a multi-valued
    # graph.
    #
    # If the color argument is nil, the next color from the default theme will
    # be used.
    #
    # @param name [String, Symbol] The name of the dataset.
    # @rbs name: (String | Symbol)
    # @param data_points [Array] The array of dataset.
    # @rbs data_points: Array[Float | Integer] | nil
    # @param color [String] The color for drawing graph of dataset.
    # @rbs color: String
    #
    # @note
    #   If you want to use a preset theme, you must set it before calling {#data}.
    #
    # @example
    #   data("Bart S.", [95, 45, 78, 89, 88, 76], '#ffcc00')
    def data(name, data_points = [], color = nil)
      store.add(name, data_points, color)
    end

    # You can manually set a minimum value instead of having the values
    # guessed for you.
    #
    # Set it after you have given all your data to the graph object.
    #
    # @return [Float] The minimum value.
    # @rbs return: Float
    def minimum_value
      min = [0.0, store.min.to_f].min
      (@minimum_value || min).to_f
    end
    attr_writer :minimum_value #: Float | Integer

    # You can manually set a maximum value, such as a percentage-based graph
    # that always goes to 100.
    #
    # If you use this, you must set it after you have given all your data to
    # the graph object.
    #
    # @return [Float] The maximum value.
    # @rbs return: Float
    def maximum_value
      (@maximum_value || store.max).to_f
    end
    attr_writer :maximum_value #: Float | Integer

    # Writes the graph to a file. Defaults to +'graph.png'+
    #
    # @param file_name [String] The file name of output image.
    # @rbs file_name: String
    #
    # @example
    #   write('graphs/my_pretty_graph.png')
    def write(file_name = 'graph.png')
      to_image.write(file_name)
    end

    # Return a rendered graph image.
    # This can use RMagick's methods to adjust the image before saving.
    #
    # @param format [String] The output image format.
    # @rbs format: String
    #
    # @return [Magick::Image] The rendered image.
    # TODO: RBS signature
    #
    # @example
    #   g = Gruff::Line.new
    #   g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
    #   g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
    #   image = g.to_image
    #   image = image.resize(400, 300).quantize(128, Magick::RGBColorspace)
    #   image.write('test.png')
    #
    def to_image(format = 'PNG')
      @to_image ||= begin
        draw
        renderer.finish
        image = renderer.image
        image.format = format
        image
      end
    end

    # Return the graph as a rendered binary blob.
    #
    # @param format [String] The image format of binary blob.
    # @rbs format: String
    #
    # @return [String] The binary string.
    # @rbs return: String
    #
    # @deprecated Please use +to_image.to_blob+ instead.
    def to_blob(format = 'PNG')
      warn '#to_blob is deprecated. Please use `to_image.to_blob` instead'
      to_image.format = format
      to_image.to_blob
    end

    # Draw a graph.
    def draw
      setup_data

      # Maybe should be done in one of the following functions for more granularity.
      unless data_given?
        draw_no_data
        return
      end

      setup_drawing

      draw_legend
      draw_line_markers
      draw_axis_labels
      draw_title
      draw_graph
    end

  protected

    attr_reader :renderer #: Gruff::Renderer

    # Perform data manipulation before calculating chart measurements
    def setup_data
      if @y_axis_increment && !@hide_line_markers
        self.maximum_value = [@y_axis_increment, maximum_value, (maximum_value / @y_axis_increment).round * @y_axis_increment].max
        self.minimum_value = [minimum_value, (minimum_value / @y_axis_increment).round * @y_axis_increment].min
      end

      sort_data if @sort # Sort data with avg largest values set first (for display)
    end

    # Calculates size of drawable area and generates normalized data.
    #
    # * line markers
    # * legend
    # * title
    def setup_drawing
      calculate_spread
      calculate_increment
      set_colors
      normalize
      setup_graph_measurements
      sort_norm_data if @sorted_drawing # Sort norm_data with avg largest values set first (for display)
    end

    attr_reader :store #: Gruff::Store

    # @rbs return: bool
    def data_given?
      @data_given ||= begin
        if store.empty?
          false
        else
          minimum_value <= store.min || maximum_value >= store.max
        end
      end
    end

    # @rbs return: Integer
    def column_count
      store.columns
    end

    # @rbs return: Integer
    def marker_count
      @marker_count ||= begin
        count = nil
        (3..7).each do |lines|
          if @spread % lines == 0.0
            count = lines and break
          end
        end
        count || 4
      end
    end

    # Make copy of data with values scaled between 0-100
    # @rbs return: Array[Gruff::Store::BasicData | Gruff::Store::XYData | Gruff::Store::XYPointsizeData]
    def normalize
      store.normalize(minimum: minimum_value, spread: @spread)
    end

    def calculate_spread
      @spread = maximum_value.to_f - minimum_value.to_f
      @spread = @spread > 0 ? @spread : 1.0
    end

    # @rbs return: bool
    def hide_title?
      @hide_title || @title.nil? || @title.empty?
    end

    # @rbs return: bool
    def hide_labels?
      @hide_line_markers
    end

    # @rbs return: bool
    def hide_left_label_area?
      @hide_line_markers && @y_axis_label.nil?
    end

    # @rbs return: bool
    def hide_bottom_label_area?
      @hide_line_markers && @x_axis_label.nil?
    end

    ##
    # Calculates size of drawable area, general font dimensions, etc.

    def setup_graph_measurements
      @graph_right = setup_right_margin
      @graph_left = setup_left_margin
      @graph_top = setup_top_margin
      @graph_bottom = setup_bottom_margin

      @graph_width = @graph_right - @graph_left
      @graph_height = @graph_bottom - @graph_top
    end

    # Draw the optional labels for the x axis and y axis.
    def draw_axis_labels
      if @x_axis_label
        # X Axis
        # Centered vertically and horizontally by setting the
        # height to 1.0 and the width to the width of the graph.
        x_axis_label_y_coordinate = @graph_bottom + (@label_margin * 2) + labels_caps_height

        text_renderer = Gruff::Renderer::Text.new(renderer, @x_axis_label, font: @marker_font)
        text_renderer.add_to_render_queue(@raw_columns, 1.0, 0.0, x_axis_label_y_coordinate)
      end

      if @y_axis_label
        # Y Axis, rotated vertically
        text_renderer = Gruff::Renderer::Text.new(renderer, @y_axis_label, font: @marker_font, rotation: -90)
        text_renderer.add_to_render_queue(1.0, @raw_rows, @left_margin + (marker_caps_height / 2.0), 0.0, Magick::CenterGravity)
      end
    end

    # Draws horizontal background lines and labels
    def draw_line_markers
      return if @hide_line_markers

      increment_scaled = (@graph_height / (@spread / @increment)).to_f

      # Draw horizontal line markers and annotate with numbers
      (0..marker_count).each do |index|
        y = @graph_top + @graph_height - (index * increment_scaled)
        draw_marker_horizontal_line(y)

        unless @hide_line_numbers
          marker_label = (BigDecimal(index.to_s) * BigDecimal(@increment.to_s)) + BigDecimal(minimum_value.to_s)
          label = y_axis_label(marker_label, @increment)
          text_renderer = Gruff::Renderer::Text.new(renderer, label, font: @marker_font)
          text_renderer.add_to_render_queue(@graph_left - @label_margin, 1.0, 0.0, y, Magick::EastGravity)
        end
      end
    end

    def draw_marker_horizontal_line(y)
      Gruff::Renderer::Line.new(renderer, color: @marker_color).render(@graph_left, y, @graph_right, y)
      Gruff::Renderer::Line.new(renderer, color: @marker_shadow_color).render(@graph_left, y + 1, @graph_right, y + 1) if @marker_shadow_color
    end

    def draw_marker_vertical_line(x, tick_mark_mode: false)
      if tick_mark_mode
        Gruff::Renderer::Line.new(renderer, color: @marker_color).render(x, @graph_bottom, x, @graph_bottom + 5)
        if @marker_shadow_color
          Gruff::Renderer::Line.new(renderer, color: @marker_shadow_color).render(x + 1, @graph_bottom, x + 1, @graph_bottom + 5)
        end
      else
        Gruff::Renderer::Line.new(renderer, color: @marker_color).render(x, @graph_bottom, x, @graph_top)
        if @marker_shadow_color
          Gruff::Renderer::Line.new(renderer, color: @marker_shadow_color).render(x + 1, @graph_bottom, x + 1, @graph_top)
        end
      end
    end

    # Return a calculation of center
    # @rbs size: Float | Integer
    # @rbs return: Float
    def center(size)
      (@raw_columns - size) / 2.0
    end

    # Draws a legend with the names of the datasets matched
    # to the colors used to draw them.
    def draw_legend
      return if @hide_legend

      legend_labels = store.data.map(&:label)
      legend_square_width = @legend_box_size # small square with color of this item
      legend_label_lines = calculate_legend_label_widths_for_each_line(legend_labels, legend_square_width)
      line_height = [legend_caps_height, legend_square_width].max + @legend_margin

      current_y_offset = begin
        if @legend_at_bottom
          @graph_bottom + @legend_margin + labels_caps_height + @label_margin + (@x_axis_label ? (@label_margin * 2) + marker_caps_height : 0)
        else
          hide_title? ? @top_margin + @title_margin : @top_margin + @title_margin + title_caps_height
        end
      end

      index = 0
      legend_label_lines.each do |(legend_labels_width, legend_labels_line)|
        current_x_offset = center(legend_labels_width)

        legend_labels_line.each do |legend_label|
          unless legend_label.empty?
            legend_label_width = calculate_width(@legend_font, legend_label)

            # Draw label
            text_renderer = Gruff::Renderer::Text.new(renderer, legend_label, font: @legend_font)
            text_renderer.add_to_render_queue(legend_label_width,
                                              legend_square_width,
                                              current_x_offset + (legend_square_width * 1.7),
                                              current_y_offset,
                                              Magick::CenterGravity)

            # Now draw box with color of this dataset
            rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: store.data[index].color)
            rect_renderer.render(current_x_offset,
                                 current_y_offset,
                                 current_x_offset + legend_square_width,
                                 current_y_offset + legend_square_width)

            current_x_offset += legend_label_width + (legend_square_width * 2.7)
          end
          index += 1
        end

        current_y_offset += line_height
      end
    end

    # Draws a title on the graph.
    def draw_title
      return if hide_title?

      metrics = text_metrics(@title_font, @title)
      if metrics.width > @raw_columns
        @title_font.size = @title_font.size * (@raw_columns / metrics.width) * 0.95
      end

      text_renderer = Gruff::Renderer::Text.new(renderer, @title, font: @title_font)
      text_renderer.add_to_render_queue(@raw_columns, 1.0, 0, @top_margin)
    end

    # Draws column labels below graph, centered over x
    #
    # @rbs x: Float | Integer
    # @rbs index: Integer
    # @rbs gravity: untyped
    # @rbs &: () -> void
    def draw_label(x, index, gravity = Magick::NorthGravity, &block)
      draw_unique_label(index) do
        if x.between?(@graph_left, @graph_right)
          y = @graph_bottom
          x_offset, y_offset = calculate_label_offset(@marker_font, @labels[index], @label_margin, @label_rotation)

          draw_label_at(1.0, 1.0, x + x_offset, y + y_offset, @labels[index], gravity: gravity, rotation: @label_rotation)
          yield if block
        end
      end
    end

    # @rbs index: Integer
    # @rbs yields: () -> void
    def draw_unique_label(index)
      return if hide_labels?

      @labels_seen ||= {}
      if !@labels[index].nil? && @labels_seen[index].nil?
        yield
        @labels_seen[index] = 1
      end
    end

    # @rbs width: Float | Integer
    # @rbs height: Float | Integer
    # @rbs x: Float | Integer
    # @rbs y: Float | Integer
    # @rbs text: String | _ToS
    # @rbs gravity: untyped
    # @rbs rotation: Float | Integer
    def draw_label_at(width, height, x, y, text, gravity: Magick::NorthGravity, rotation: 0)
      label_text = truncate_label_text(text)
      text_renderer = Gruff::Renderer::Text.new(renderer, label_text, font: @marker_font, rotation: rotation)
      text_renderer.add_to_render_queue(width, height, x, y, gravity)
    end

    # Draws the data value over the data point in bar graphs
    #
    # @rbs width: Float | Integer
    # @rbs height: Float | Integer
    # @rbs x_offset: Float | Integer
    # @rbs y_offset: Float | Integer
    # @rbs data_point: String | _ToS
    # @rbs gravity: untyped
    def draw_value_label(width, height, x_offset, y_offset, data_point, gravity: Magick::CenterGravity)
      return if @hide_line_markers

      draw_label_at(width, height, x_offset, y_offset, data_point, gravity: gravity)
    end

    # Shows an error message because you have no data.
    def draw_no_data
      font = @no_data_font
      text_renderer = Gruff::Renderer::Text.new(renderer, @no_data_message, font: font)
      text_renderer.render(@raw_columns, @raw_rows, 0, 0, Magick::CenterGravity)
    end

    def draw_graph
      raise 'Should implement this method at inherited class.'
    end

    # Resets everything to defaults (except data).
    def reset_themes
      @theme_options = {}
    end

    # @rbs value: Float | Integer
    # @rbs max_value: Float | Integer
    # @rbs return: Float | Integer
    def clip_value_if_greater_than(value, max_value)
      [value, max_value].min
    end

    # @rbs i: Integer
    # @rbs return: Integer | Float | BigDecimal
    # TODO: Fix return RBS signature
    def significant(i)
      return 1.0 if i == 0 # Keep from going into infinite loop

      inc = BigDecimal(i.to_s)
      factor = BigDecimal('1.0')
      while inc < 10
        inc *= 10
        factor /= 10
      end

      while inc > 100
        inc /= 10
        factor *= 10
      end

      res = inc.floor * factor
      if res.to_i.to_f == res
        res.to_i
      elsif res.to_f == res
        res.to_f
      else
        res
      end
    end

    # Sort with largest overall summed value at front of array.
    def sort_data
      store.sort_data!
    end

    # Set the color for each data set unless it was given in the data(...) call.
    def set_colors
      store.change_colors(@colors)
    end

    # Sort with largest overall summed value at front of array so it shows up
    # correctly in the drawn graph.
    def sort_norm_data
      store.sort_norm_data!
    end

  private

    # @rbs return: Float
    def marker_caps_height
      hide_bottom_label_area? ? 0.0 : calculate_caps_height(@marker_font)
    end

    # @rbs return: Float
    def labels_caps_height
      hide_bottom_label_area? ? 0.0 : calculate_labels_height(@marker_font)
    end

    # @rbs return: Float
    def title_caps_height
      hide_title? ? 0.0 : Float(calculate_caps_height(@title_font) * @title.lines.to_a.size)
    end

    # @rbs return: Float
    def legend_caps_height
      @hide_legend ? 0.0 : calculate_caps_height(@legend_font)
    end

    # @rbs return: Float | Integer
    def setup_left_margin
      return @left_margin if hide_left_label_area?

      longest_left_label_width = begin
        if @has_left_labels
          @labels.values.map { |value| calculate_width(@marker_font, truncate_label_text(value.to_s)) }.max || 0
        else
          label = y_axis_label(maximum_value, @increment)
          calculate_width(@marker_font, truncate_label_text(label))
        end
      end

      line_number_width = begin
        if !@has_left_labels && (@hide_line_markers || @hide_line_numbers)
          0.0
        else
          longest_left_label_width + @label_margin
        end
      end
      y_axis_label_width = @y_axis_label.nil? ? 0.0 : marker_caps_height + (@label_margin * 2)

      bottom_label_width = extra_left_room_for_long_label

      margin = line_number_width + y_axis_label_width
      @left_margin + [margin, bottom_label_width].max
    end

    # @rbs return: Float
    def setup_right_margin
      @raw_columns - (@hide_line_markers ? @right_margin : @right_margin + extra_right_room_for_long_label)
    end

    # @rbs return: Float | Integer
    def extra_left_room_for_long_label
      if require_extra_side_margin?
        width = calculate_width(@marker_font, truncate_label_text(@labels[0]), rotation: @label_rotation)
        result = begin
          case @label_rotation
          when 0
            width / 2.0
          when 0..45
            0
          when -45..0
            width
          end
        end
        result || 0
      else
        0
      end
    end

    # @rbs return: Float | Integer
    def extra_right_room_for_long_label
      # Make space for half the width of the rightmost column label.
      # Might be greater than the number of columns if between-style bar markers are used.
      last_label = @labels.keys.max.to_i
      if last_label >= (column_count - 1) && require_extra_side_margin?
        width = calculate_width(@marker_font, truncate_label_text(@labels[last_label]), rotation: @label_rotation)
        result = begin
          case @label_rotation
          when 0
            width / 2.0
          when 0..45
            width
          when -45..0
            0
          end
        end
        result || 0
      else
        0
      end
    end

    # @rbs return: bool
    def require_extra_side_margin?
      !hide_bottom_label_area? && @center_labels_over_point
    end

    # @rbs return: Float
    def setup_top_margin
      # When @hide title, leave a title_margin space for aesthetics.
      # Same with @hide_legend
      @top_margin +
        (hide_title? ? @title_margin : title_caps_height + @title_margin) +
        (@hide_legend || @legend_at_bottom ? @legend_margin : calculate_legend_height + @legend_margin)
    end

    # @rbs return: Float
    def setup_bottom_margin
      graph_bottom_margin = hide_bottom_label_area? ? @bottom_margin : @bottom_margin + labels_caps_height + @label_margin
      graph_bottom_margin += (calculate_legend_height + @legend_margin) if @legend_at_bottom

      x_axis_label_height = @x_axis_label.nil? ? 0.0 : marker_caps_height + (@label_margin * 2)
      @raw_rows - graph_bottom_margin - x_axis_label_height
    end

    # @rbs text: String | _ToS
    # @rbs return: String
    def truncate_label_text(text)
      text = text.to_s
      return text if text.size <= @label_max_size

      if @label_truncation_style == :trailing_dots
        # 4 because '...' takes up 3 chars
        text = "#{text[0..(@label_max_size - 4)]}..." if @label_max_size > 3
      else
        text = text[0..(@label_max_size - 1)]
      end
      text || ''
    end

    # Return a formatted string representing a number value that should be
    # printed as a label.
    #
    # @rbs value: Float | Integer | BigDecimal
    # @rbs increment: Float | Integer | BigDecimal
    # @rbs return: String
    def label(value, increment)
      label = begin
        if increment
          if increment >= 10 || (increment * 1) == (increment * 1).to_i.to_f
            sprintf('%0i', value)
          elsif increment >= 1.0 || (increment * 10) == (increment * 10).to_i.to_f
            sprintf('%0.1f', value)
          elsif increment >= 0.1 || (increment * 100) == (increment * 100).to_i.to_f
            sprintf('%0.2f', value)
          elsif increment >= 0.01 || (increment * 1000) == (increment * 1000).to_i.to_f
            sprintf('%0.3f', value)
          elsif increment >= 0.001 || (increment * 10_000) == (increment * 10_000).to_i.to_f
            sprintf('%0.4f', value)
          else
            value.to_s
          end
        elsif (@spread % (marker_count == 0 ? 1 : marker_count) == 0) || !@y_axis_increment.nil?
          value.to_i.to_s
        elsif @spread > 10.0
          sprintf('%0i', value)
        elsif @spread >= 3.0
          sprintf('%0.2f', value)
        else
          value.to_s
        end
      end

      parts = label.split('.')
      parts[0] = parts[0].commify # steep:ignore
      parts.join('.')
    end

    # @rbs value: Float | Integer | BigDecimal
    # @rbs increment: Float | Integer | BigDecimal
    # @rbs return: String
    def x_axis_label(value, increment)
      if @x_axis_label_format
        @x_axis_label_format.call(value)
      else
        label(value, increment)
      end
    end

    # @rbs value: Float | Integer | BigDecimal
    # @rbs increment: Float | Integer
    # @rbs return: String
    def y_axis_label(value, increment)
      if @y_axis_label_format
        @y_axis_label_format.call(value)
      else
        label(value, increment)
      end
    end

    # TODO: RBS signature
    def calculate_legend_label_widths_for_each_line(legend_labels, legend_square_width)
      label_widths = [[]]
      label_lines = [[]]
      legend_labels.each do |label|
        if label.empty?
          label_width = 0.0
        else
          width = calculate_width(@legend_font, label)
          label_width = width + (legend_square_width * 2.7)
        end
        label_widths.last.push label_width
        label_lines.last.push label

        if label_widths.last.sum > (@raw_columns * 0.9)
          label_widths.push [label_widths.last.pop]
          label_lines.push [label_lines.last.pop]
        end
      end

      label_widths.map(&:sum).zip(label_lines)
    end

    # TODO: RBS signature
    def calculate_legend_height
      return 0.0 if @hide_legend

      legend_labels = store.data.map(&:label)
      legend_label_lines = calculate_legend_label_widths_for_each_line(legend_labels, @legend_box_size)
      line_height = [legend_caps_height, @legend_box_size].max

      (line_height * legend_label_lines.count) + (@legend_margin * (legend_label_lines.count - 1))
    end

    # Returns the height of the capital letter 'X' for the current font and
    # size.
    #
    # Not scaled since it deals with dimensions that the regular scaling will
    # handle.
    #
    # @rbs font: Gruff::Font
    # @rbs return: Float
    def calculate_caps_height(font)
      calculate_height(font, 'X')
    end

    # @rbs font: Gruff::Font
    # @rbs return: Float
    def calculate_labels_height(font)
      @labels.values.map { |label| calculate_height(font, label, rotation: @label_rotation) }.max || marker_caps_height
    end

    # Returns the height of a string at this point size.
    #
    # Not scaled since it deals with dimensions that the regular scaling will
    # handle.
    #
    # @rbs font: Gruff::Font
    # @rbs text: String
    # @rbs rotation: Float | Integer
    # @rbs return: Float
    def calculate_height(font, text, rotation: 0)
      text = text.to_s
      return 0.0 if text.empty?

      metrics = text_metrics(font, text, rotation: rotation)
      # Calculate manually because it does not return the height after rotation.
      (metrics.width * Math.sin(deg2rad(rotation))).abs + (metrics.height * Math.cos(deg2rad(rotation))).abs
    end

    # Returns the width of a string at this point size.
    #
    # Not scaled since it deals with dimensions that the regular
    # scaling will handle.
    #
    # @rbs font: Gruff::Font
    # @rbs text: String
    # @rbs rotation: Float | Integer
    # @rbs return: Float | Integer
    def calculate_width(font, text, rotation: 0)
      text = text.to_s
      return 0 if text.empty?

      metrics = text_metrics(font, text, rotation: rotation)
      # Calculate manually because it does not return the width after rotation.
      (metrics.width * Math.cos(deg2rad(rotation))).abs - (metrics.height * Math.sin(deg2rad(rotation))).abs
    end

    # @rbs font: Gruff::Font
    # @rbs text: String
    # @rbs rotation: Float | Integer
    # @rbs return: untyped
    def text_metrics(font, text, rotation: 0)
      Gruff::Renderer::Text.new(renderer, text, font: font, rotation: rotation).metrics
    end

    # @rbs return: Float | Integer | BigDecimal
    def calculate_increment
      if @y_axis_increment.nil?
        # Try to use a number of horizontal lines that will come out even.
        #
        # TODO Do the same for larger numbers...100, 75, 50, 25
        @increment = @spread > 0 && marker_count > 0 ? significant(@spread / marker_count) : 1.0
      else
        # TODO: Make this work for negative values
        self.marker_count = (@spread / @y_axis_increment).to_i
        @increment = @y_axis_increment.to_f
      end
    end

    # @rbs font: Gruff::Font
    # @rbs label: String
    # @rbs margin: Float | Integer
    # @rbs rotation: Float | Integer
    # @rbs return: [Float | Integer, Float | Integer]
    def calculate_label_offset(font, label, margin, rotation)
      width = calculate_width(font, label, rotation: rotation)
      height = calculate_height(font, label, rotation: rotation)
      x_offset = begin
        case rotation
        when 0
          0
        when 0..45
          width / 2.0
        when -45..0
          -(width / 2.0)
        end
      end
      x_offset ||= 0
      y_offset = [(height / 2.0), margin].max

      [x_offset, y_offset]
    end

    # Used for degree <=> radian conversions
    # @rbs angle: Float | Integer
    # @rbs return: Float
    def deg2rad(angle)
      (angle * Math::PI) / 180.0
    end

    # @rbs angle: Float | Integer
    # @rbs return: Float
    def rad2deg(angle)
      (angle / Math::PI) * 180.0
    end
  end

  class IncorrectNumberOfDatasetsException < StandardError
  end
end

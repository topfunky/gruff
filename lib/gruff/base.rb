# frozen_string_literal: true

require 'rmagick'
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
# See Gruff::Base#theme= for setting themes.

module Gruff
  class Base
    # Space around text elements. Mostly used for vertical spacing
    LEGEND_MARGIN = TITLE_MARGIN = 20.0
    LABEL_MARGIN = 10.0
    DEFAULT_MARGIN = 20.0

    DEFAULT_TARGET_WIDTH = 800.0

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

    # Manually set increment of the vertical marking lines
    attr_accessor :x_axis_increment

    # Manually set increment of the horizontal marking lines
    attr_accessor :y_axis_increment

    # Height of staggering between labels (Bar graph only)
    attr_accessor :label_stagger_height

    # Truncates labels if longer than max specified
    attr_accessor :label_max_size

    # How truncated labels visually appear if they exceed label_max_size
    # :absolute - does not show trailing dots to indicate truncation. This is
    #   the default.
    # :trailing_dots - shows trailing dots to indicate truncation (note
    #   that label_max_size must be greater than 3).
    attr_accessor :label_truncation_style

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

    # Same as font but for the title.
    attr_accessor :title_font

    # Specifies whether to draw the title bolded or not.
    attr_accessor :bold_title

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
    # Will be scaled down if the graph is smaller than 800px wide.
    attr_accessor :legend_font_size

    # Display the legend under the graph
    attr_accessor :legend_at_bottom

    # The font size of the labels around the graph
    attr_accessor :marker_font_size

    # The color of the auxiliary lines
    attr_accessor :marker_color
    attr_accessor :marker_shadow_color

    # The number of horizontal lines shown for reference
    attr_accessor :marker_count

    # Set to true if you want the data sets sorted with largest avg values drawn
    # first.
    attr_accessor :sort

    # Set to true if you want the data sets drawn with largest avg values drawn
    # first.  This does not affect the legend.
    attr_accessor :sorted_drawing

    # Experimental
    attr_accessor :additional_line_values

    # Optionally set the size of the colored box by each item in the legend.
    # Default is 20.0
    #
    # Will be scaled down if graph is smaller than 800px wide.
    attr_accessor :legend_box_size

    # With Side Bars use the data label for the marker value to the left of the bar
    # Default is false
    attr_accessor :use_data_label

    # If one numerical argument is given, the graph is drawn at 4/3 ratio
    # according to the given width (800 results in 800x600, 400 gives 400x300,
    # etc.).
    #
    # Or, send a geometry string for other ratios ('800x400', '400x225').
    #
    # Looks for Bitstream Vera as the default font. Expects an environment var
    # of MAGICK_FONT_PATH to be set. (Uses RMagick's default font otherwise.)
    def initialize(target_width = DEFAULT_TARGET_WIDTH)
      if target_width.is_a?(String)
        geometric_width, geometric_height = target_width.split('x')
        @columns = geometric_width.to_f
        @rows = geometric_height.to_f
      else
        @columns = target_width.to_f
        @rows = target_width.to_f * 0.75
      end
      @columns.freeze
      @rows.freeze

      initialize_ivars

      self.theme = Themes::KEYNOTE
    end

    # Set instance variables for this object.
    #
    # Subclasses can override this, call super, then set values separately.
    #
    # This makes it possible to set defaults in a subclass but still allow
    # developers to change this values in their program.
    def initialize_ivars
      # Internal for calculations
      @raw_columns = DEFAULT_TARGET_WIDTH
      @raw_rows = DEFAULT_TARGET_WIDTH * (@rows / @columns)
      @raw_columns.freeze
      @raw_rows.freeze

      @marker_count = nil
      @maximum_value = @minimum_value = nil
      @increment = nil
      @labels = {}
      @labels_seen = {}
      @sort = false
      @sorted_drawing = false
      @title = nil
      @title_font = nil

      @scale = @columns / @raw_columns

      @font = nil
      @bold_title = true

      @marker_font_size = 21.0
      @legend_font_size = 20.0
      @title_font_size = 36.0

      @top_margin = @bottom_margin = @left_margin = @right_margin = DEFAULT_MARGIN
      @legend_margin = LEGEND_MARGIN
      @title_margin = TITLE_MARGIN

      @legend_box_size = 20.0

      @no_data_message = 'No Data'

      @hide_line_markers = @hide_legend = @hide_title = @hide_line_numbers = @legend_at_bottom = false
      @center_labels_over_point = true
      @has_left_labels = false
      @label_stagger_height = 0
      @label_max_size = 0
      @label_truncation_style = :absolute

      @additional_line_values = []
      @additional_line_colors = []
      @theme_options = {}

      @use_data_label = false
      @x_axis_increment = nil
      @x_axis_label = @y_axis_label = nil
      @y_axis_increment = nil

      @store = Gruff::Store.new(Gruff::Store::BaseData)
    end

    # Sets the top, bottom, left and right margins to +margin+.
    def margins=(margin)
      @top_margin = @left_margin = @right_margin = @bottom_margin = margin
    end

    # Sets the font for graph text to the font at +font_path+.
    def font=(font_path)
      @font = font_path
      Gruff::Renderer.font = @font
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
    def replace_colors(color_list = [])
      @colors = color_list
    end

    # You can set a theme manually. Assign a hash to this method before you
    # send your data.
    #
    #  graph.theme = {
    #    :colors => %w(orange purple green white red),
    #    :marker_color => 'blue',
    #    :background_colors => ['black', 'grey', :top_bottom]
    #  }
    #
    # :background_image => 'squirrel.png' is also possible.
    #
    # (Or hopefully something better looking than that.)
    #
    def theme=(options)
      reset_themes

      defaults = {
        colors: %w[black white],
        additional_line_colors: [],
        marker_color: 'white',
        marker_shadow_color: nil,
        font_color: 'black',
        background_colors: nil,
        background_image: nil
      }
      @theme_options = defaults.merge options

      @colors = @theme_options[:colors]
      @marker_color = @theme_options[:marker_color]
      @marker_shadow_color = @theme_options[:marker_shadow_color]
      @font_color = @theme_options[:font_color] || @marker_color
      @additional_line_colors = @theme_options[:additional_line_colors]

      Gruff::Renderer.setup(@columns, @rows, @font, @scale, @theme_options)
    end

    def theme_keynote
      self.theme = Themes::KEYNOTE
    end

    def theme_37signals
      self.theme = Themes::THIRTYSEVEN_SIGNALS
    end

    def theme_rails_keynote
      self.theme = Themes::RAILS_KEYNOTE
    end

    def theme_odeo
      self.theme = Themes::ODEO
    end

    def theme_pastel
      self.theme = Themes::PASTEL
    end

    def theme_greyscale
      self.theme = Themes::GREYSCALE
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
    def data(name, data_points = [], color = nil)
      store.add(name, data_points, color)
    end

    # You can manually set a minimum value instead of having the values
    # guessed for you.
    #
    # Set it after you have given all your data to the graph object.
    attr_writer :minimum_value

    def minimum_value
      @minimum_value || store.min
    end

    # You can manually set a maximum value, such as a percentage-based graph
    # that always goes to 100.
    #
    # If you use this, you must set it after you have given all your data to
    # the graph object.
    attr_writer :maximum_value

    def maximum_value
      @maximum_value || store.max
    end

    # Writes the graph to a file. Defaults to 'graph.png'
    #
    # Example:
    #   write('graphs/my_pretty_graph.png')
    def write(file_name = 'graph.png')
      draw
      Gruff::Renderer.write(file_name)
    end

    # Return the graph as a rendered binary blob.
    def to_blob(file_format = 'PNG')
      draw
      Gruff::Renderer.to_blob(file_format)
    end

  protected

    # Overridden by subclasses to do the actual plotting of the graph.
    #
    # Subclasses should start by calling super() for this method.
    def draw
      # Maybe should be done in one of the following functions for more granularity.
      unless data_given?
        draw_no_data
        return
      end

      setup_data
      setup_drawing

      draw_legend
      draw_line_markers
      draw_axis_labels
      draw_title
    end

    # Perform data manipulation before calculating chart measurements
    def setup_data # :nodoc:
      if @y_axis_increment && !@hide_line_markers
        self.maximum_value = [@y_axis_increment, maximum_value, (maximum_value.to_f / @y_axis_increment).round * @y_axis_increment].max
        self.minimum_value = [minimum_value, (minimum_value.to_f / @y_axis_increment).round * @y_axis_increment].min
      end
    end

    # Calculates size of drawable area and generates normalized data.
    #
    # * line markers
    # * legend
    # * title
    def setup_drawing
      calculate_spread
      calculate_increment
      sort_data if @sort # Sort data with avg largest values set first (for display)
      set_colors
      normalize
      setup_graph_measurements
      sort_norm_data if @sorted_drawing # Sort norm_data with avg largest values set first (for display)
    end

    attr_reader :store

    def data_given?
      @data_given ||= begin
        if store.empty?
          false
        else
          minimum_value <= store.min || maximum_value >= store.max
        end
      end
    end

    def column_count
      store.columns
    end

    # Make copy of data with values scaled between 0-100
    def normalize
      store.normalize(minimum: minimum_value, spread: @spread)
    end

    def calculate_spread # :nodoc:
      @spread = maximum_value.to_f - minimum_value.to_f
      @spread = @spread > 0 ? @spread : 1
    end

    ##
    # Calculates size of drawable area, general font dimensions, etc.

    def setup_graph_measurements
      @marker_caps_height = @hide_line_markers ? 0 : calculate_caps_height(@marker_font_size)
      @title_caps_height = (@hide_title || @title.nil?) ? 0 : calculate_caps_height(@title_font_size) * @title.lines.to_a.size
      @legend_caps_height = @hide_legend ? 0 : calculate_caps_height(@legend_font_size)

      if @hide_line_markers
        @graph_left = @left_margin
        @graph_right_margin = @right_margin
        @graph_bottom_margin = @bottom_margin
      else
        if @has_left_labels
          longest_left_label_width = calculate_width(@marker_font_size,
                                                     labels.values.reduce('') { |value, memo| (value.to_s.length > memo.to_s.length) ? value : memo }) * 1.25
        else
          longest_left_label_width = calculate_width(@marker_font_size,
                                                     label(maximum_value.to_f, @increment))
        end

        # Shift graph if left line numbers are hidden
        line_number_width = @hide_line_numbers && !@has_left_labels ? 0.0 : (longest_left_label_width + LABEL_MARGIN * 2)

        @graph_left = @left_margin + line_number_width + (@y_axis_label.nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN * 2)

        # Make space for half the width of the rightmost column label.
        # Might be greater than the number of columns if between-style bar markers are used.
        last_label = @labels.keys.max.to_i
        extra_room_for_long_label = begin
          (last_label >= (column_count - 1) && @center_labels_over_point) ? calculate_width(@marker_font_size, @labels[last_label]) / 2.0 : 0
        end
        @graph_right_margin = @right_margin + extra_room_for_long_label

        @graph_bottom_margin = @bottom_margin + @marker_caps_height + LABEL_MARGIN
      end

      @graph_right = @raw_columns - @graph_right_margin
      @graph_width = @raw_columns - @graph_left - @graph_right_margin

      # When @hide title, leave a title_margin space for aesthetics.
      # Same with @hide_legend
      @graph_top = begin
        if @legend_at_bottom
          @top_margin
        else
          @top_margin +
            (@hide_title ? title_margin : @title_caps_height + title_margin) +
            (@hide_legend ? legend_margin : @legend_caps_height + legend_margin)
        end
      end

      x_axis_label_height = @x_axis_label.nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN
      # FIXME: Consider chart types other than bar
      @graph_bottom = @raw_rows - @graph_bottom_margin - x_axis_label_height - @label_stagger_height
      @graph_height = @graph_bottom - @graph_top
    end

    # Draw the optional labels for the x axis and y axis.
    def draw_axis_labels
      if @x_axis_label
        # X Axis
        # Centered vertically and horizontally by setting the
        # height to 1.0 and the width to the width of the graph.
        x_axis_label_y_coordinate = @graph_bottom + LABEL_MARGIN * 2 + @marker_caps_height

        # TODO: Center between graph area
        text_renderer = Gruff::Renderer::Text.new(@x_axis_label, font: @font, size: @marker_font_size, color: @font_color)
        text_renderer.render(@raw_columns, 1.0, 0.0, x_axis_label_y_coordinate)
      end

      if @y_axis_label
        # Y Axis, rotated vertically
        text_renderer = Gruff::Renderer::Text.new(@y_axis_label, font: @font, size: @marker_font_size, color: @font_color, rotation: -90)
        text_renderer.render(1.0, @raw_rows, @left_margin + @marker_caps_height / 2.0, 0.0, Magick::CenterGravity)
      end
    end

    # Draws horizontal background lines and labels
    def draw_line_markers
      return if @hide_line_markers

      increment_scaled = @graph_height.to_f / (@spread / @increment)

      # Draw horizontal line markers and annotate with numbers
      (0..@marker_count).each do |index|
        y = @graph_top + @graph_height - index.to_f * increment_scaled

        Gruff::Renderer::Line.new(color: @marker_color).render(@graph_left, y, @graph_right, y)
        #If the user specified a marker shadow color, draw a shadow just below it
        if @marker_shadow_color
          Gruff::Renderer::Line.new(color: @marker_shadow_color).render(@graph_left, y + 1, @graph_right, y + 1)
        end

        marker_label = BigDecimal(index.to_s) * BigDecimal(@increment.to_s) + BigDecimal(minimum_value.to_s)

        unless @hide_line_numbers
          label = label(marker_label, @increment)
          text_renderer = Gruff::Renderer::Text.new(label, font: @font, size: @marker_font_size, color: @font_color)
          text_renderer.render(@graph_left - LABEL_MARGIN, 1.0, 0.0, y, Magick::EastGravity)
        end
      end
    end

    ##
    # Return the sum of values in an array.
    #
    # Duplicated to not conflict with active_support in Rails.

    def sum(arr)
      arr.reduce(0) { |i, m| m + i }
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

      legend_labels = store.data.map(&:label)

      legend_square_width = @legend_box_size # small square with color of this item

      # May fix legend drawing problem at small sizes
      label_widths = [[]] # Used to calculate line wrap
      legend_labels.each do |label|
        metrics = Renderer::Text.metrics(label, @legend_font_size)
        label_width = metrics.width + legend_square_width * 2.7
        label_widths.last.push label_width

        if sum(label_widths.last) > (@raw_columns * 0.9)
          label_widths.push [label_widths.last.pop]
        end
      end

      current_x_offset = center(sum(label_widths.first))
      current_y_offset = begin
        if @legend_at_bottom
          @graph_height + title_margin
        else
          @hide_title ? @top_margin + title_margin : @top_margin + title_margin + @title_caps_height
        end
      end

      legend_labels.each_with_index do |legend_label, index|
        # Draw label
        text_renderer = Gruff::Renderer::Text.new(legend_label, font: @font, size: @legend_font_size, color: @font_color)
        text_renderer.render(@raw_columns, 1.0, current_x_offset + (legend_square_width * 1.7), current_y_offset, Magick::WestGravity)

        # Now draw box with color of this dataset
        rect_renderer = Gruff::Renderer::Rectangle.new(color: store.data[index].color)
        rect_renderer.render(current_x_offset,
                             current_y_offset - legend_square_width / 2.0,
                             current_x_offset + legend_square_width,
                             current_y_offset + legend_square_width / 2.0)

        metrics = Renderer::Text.metrics(legend_label, legend_font_size)
        current_string_offset = metrics.width + (legend_square_width * 2.7)

        # Handle wrapping
        label_widths.first.shift
        if label_widths.first.empty?
          label_widths.shift
          current_x_offset = center(sum(label_widths.first)) unless label_widths.empty?
          line_height = [@legend_caps_height, legend_square_width].max + legend_margin
          unless label_widths.empty?
            # Wrap to next line and shrink available graph dimensions
            current_y_offset += line_height
            @graph_top += line_height
            @graph_height = @graph_bottom - @graph_top
          end
        else
          current_x_offset += current_string_offset
        end
      end
    end

    # Draws a title on the graph.
    def draw_title
      return if @hide_title || @title.nil?

      font = (@title_font || @font) if @title_font || @font
      font_weight = @bold_title ? Magick::BoldWeight : Magick::NormalWeight
      text_renderer = Gruff::Renderer::Text.new(@title, font: font, size: @title_font_size, color: @font_color, weight: font_weight)
      text_renderer.render(@raw_columns, 1.0, 0, @top_margin)
    end

    # Draws column labels below graph, centered over x_offset
    #--
    # TODO Allow WestGravity as an option
    def draw_label(x_offset, index)
      draw_unique_label(index) do
        y_offset = @graph_bottom + LABEL_MARGIN

        # TESTME
        # FIXME: Consider chart types other than bar
        # TODO: See if index.odd? is the best stragegy
        y_offset += @label_stagger_height if index.odd?

        label_text = labels[index].to_s

        # TESTME
        # FIXME: Consider chart types other than bar
        if label_text.size > @label_max_size
          if @label_truncation_style == :trailing_dots
            if @label_max_size > 3
              # 4 because '...' takes up 3 chars
              label_text = "#{label_text[0..(@label_max_size - 4)]}..."
            end
          else # @label_truncation_style is :absolute (default)
            label_text = label_text[0..(@label_max_size - 1)]
          end

        end

        if x_offset >= @graph_left && x_offset <= @graph_right
          text_renderer = Gruff::Renderer::Text.new(label_text, font: @font, size: @marker_font_size, color: @font_color)
          text_renderer.render(1.0, 1.0, x_offset, y_offset)
        end
      end
    end

    def draw_unique_label(index)
      return if @hide_line_markers

      if !@labels[index].nil? && @labels_seen[index].nil?
        yield
        @labels_seen[index] = 1
      end
    end

    # Draws the data value over the data point in bar graphs
    def draw_value_label(x_offset, y_offset, data_point, bar_value = false)
      return if @hide_line_markers && !bar_value

      text_renderer = Gruff::Renderer::Text.new(data_point, font: @font, size: @marker_font_size, color: @font_color)
      text_renderer.render(1.0, 1.0, x_offset, y_offset)
    end

    # Shows an error message because you have no data.
    def draw_no_data
      text_renderer = Gruff::Renderer::Text.new(@no_data_message, font: @font, size: 80, color: @font_color)
      text_renderer.render(@raw_columns, @raw_rows / 2.0, 0, 10, Magick::CenterGravity)
    end

    # Resets everything to defaults (except data).
    def reset_themes
      @labels_seen = {}
      @theme_options = {}
    end

    def scale(value) # :nodoc:
      value * @scale
    end

    # Return a comparable fontsize for the current graph.
    def scale_fontsize(value)
      value * @scale
    end

    def clip_value_if_greater_than(value, max_value) # :nodoc:
      (value > max_value) ? max_value : value
    end

    def significant(i) # :nodoc:
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
      store.set_colors!(@colors)
    end

    # Sort with largest overall summed value at front of array so it shows up
    # correctly in the drawn graph.
    def sort_norm_data
      store.sort_norm_data!
    end

  private

    # Return a formatted string representing a number value that should be
    # printed as a label.
    def label(value, increment)
      label = if increment
                if increment >= 10 || (increment * 1) == (increment * 1).to_i.to_f
                  sprintf('%0i', value)
                elsif increment >= 1.0 || (increment * 10) == (increment * 10).to_i.to_f
                  sprintf('%0.1f', value)
                elsif increment >= 0.1 || (increment * 100) == (increment * 100).to_i.to_f
                  sprintf('%0.2f', value)
                elsif increment >= 0.01 || (increment * 1000) == (increment * 1000).to_i.to_f
                  sprintf('%0.3f', value)
                elsif increment >= 0.001 || (increment * 10000) == (increment * 10000).to_i.to_f
                  sprintf('%0.4f', value)
                else
                  value.to_s
                end
              elsif (@spread.to_f % (@marker_count.to_f == 0 ? 1 : @marker_count.to_f) == 0) || !@y_axis_increment.nil?
                value.to_i.to_s
              elsif @spread > 10.0
                sprintf('%0i', value)
              elsif @spread >= 3.0
                sprintf('%0.2f', value)
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
      metrics = Renderer::Text.metrics('X', font_size)
      metrics.height
    end

    # Returns the width of a string at this pointsize.
    #
    # Not scaled since it deals with dimensions that the regular
    # scaling will handle.
    def calculate_width(font_size, text)
      return 0 if text.nil?

      metrics = Renderer::Text.metrics(text, font_size)
      metrics.width
    end

    def calculate_increment
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
        @increment = (@spread > 0 && @marker_count > 0) ? significant(@spread / @marker_count) : 1
      else
        # TODO: Make this work for negative values
        @marker_count = (@spread / @y_axis_increment).to_i
        @increment = @y_axis_increment
      end
    end

    # Used for degree => radian conversions
    def deg2rad(angle)
      angle * (Math::PI / 180.0)
    end
  end

  class IncorrectNumberOfDatasetsException < StandardError
  end
end

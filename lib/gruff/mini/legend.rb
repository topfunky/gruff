module Gruff
  module Mini
    module Legend

      attr_accessor :hide_mini_legend, :legend_position

      def initialize(*)
        @hide_mini_legend = false
        @legend_position = nil
        super
      end

      ##
      # The canvas needs to be bigger so we can put the legend beneath it.

      def expand_canvas_for_vertical_legend
        return if @hide_mini_legend

        @legend_labels = @data.collect {|item| item[Gruff::Base::DATA_LABEL_INDEX] }

        legend_height = scale_fontsize(
                                       @data.length * calculate_line_height +
                                       @top_margin + @bottom_margin)

        @original_rows = @raw_rows
        @original_columns = @raw_columns

        case @legend_position
        when :right then
          @rows = [@rows, legend_height].max
          @columns += calculate_legend_width + @left_margin
        else
          @rows += @data.length * calculate_caps_height(scale_fontsize(@legend_font_size)) * 1.7
        end
        render_background
      end

      def calculate_line_height
        calculate_caps_height(@legend_font_size) * 1.7
      end

      def calculate_legend_width
        width = @legend_labels.map { |label| calculate_width(@legend_font_size, label) }.max
        scale_fontsize(width + 40*1.7)
      end

      ##
      # Draw the legend beneath the existing graph.

      def draw_vertical_legend
        return if @hide_mini_legend

        legend_square_width = 40.0 # small square with color of this item
        @legend_left_margin = 100.0
        legend_top_margin = 40.0

        # May fix legend drawing problem at small sizes
        @d.font = @font if @font
        @d.pointsize = @legend_font_size

        case @legend_position
        when :right then
          current_x_offset = @original_columns + @left_margin
          current_y_offset = @top_margin + legend_top_margin
        else
          current_x_offset = @legend_left_margin
          current_y_offset = @original_rows + legend_top_margin
        end

        debug { @d.line 0.0, current_y_offset, @raw_columns, current_y_offset }

        @legend_labels.each_with_index do |legend_label, index|

          # Draw label
          @d.fill = @font_color
          @d.font = @font if @font
          @d.pointsize = scale_fontsize(@legend_font_size)
          @d.stroke = 'transparent'
          @d.font_weight = Magick::NormalWeight
          @d.gravity = Magick::WestGravity
          @d = @d.annotate_scaled( @base_image,
                                   @raw_columns, 1.0,
                                   current_x_offset + (legend_square_width * 1.7), current_y_offset,
                                   truncate_legend_label(legend_label), @scale)

          # Now draw box with color of this dataset
          @d = @d.stroke 'transparent'
          @d = @d.fill @data[index][Gruff::Base::DATA_COLOR_INDEX]
          @d = @d.rectangle(current_x_offset,
                            current_y_offset - legend_square_width / 2.0,
                            current_x_offset + legend_square_width,
                            current_y_offset + legend_square_width / 2.0)

          current_y_offset += calculate_line_height
        end
        @color_index = 0
      end

      ##
      # Shorten long labels so they will fit on the canvas.
      #
      #   Department of Hu...

      def truncate_legend_label(label)
        truncated_label = label.to_s
        while calculate_width(scale_fontsize(@legend_font_size), truncated_label) > (@columns - @legend_left_margin - @right_margin) && (truncated_label.length > 1)
          truncated_label = truncated_label[0..truncated_label.length-2]
        end
        truncated_label + (truncated_label.length < label.to_s.length ? "..." : '')
      end

    end
  end
end

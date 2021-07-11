# frozen_string_literal: true

module Gruff
  module Mini
    # A module to handle the small legend.
    # @private
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

        @legend_labels = store.data.map(&:label)

        legend_height = scale_fontsize(store.length * calculate_line_height + @top_margin + @bottom_margin)

        @original_rows = @raw_rows
        @original_columns = @raw_columns

        case @legend_position
        when :right
          @rows = [@rows, legend_height].max
          @columns += calculate_legend_width + @left_margin
        else
          font = @legend_font.dup
          font.size = scale_fontsize(font.size)
          @rows += store.length * calculate_caps_height(font) * 1.7
        end

        @renderer = Gruff::Renderer.new(@columns, @rows, @scale, @theme_options)
      end

      def calculate_line_height
        calculate_caps_height(@legend_font) * 1.7
      end

      def calculate_legend_width
        width = @legend_labels.map { |label| calculate_width(@legend_font, label) }.max
        scale_fontsize(width + 40 * 1.7)
      end

      ##
      # Draw the legend beneath the existing graph.

      def draw_vertical_legend
        return if @hide_mini_legend

        legend_square_width = 40.0 # small square with color of this item
        @legend_left_margin = 100.0
        legend_top_margin = 40.0

        case @legend_position
        when :right
          current_x_offset = @original_columns + @left_margin
          current_y_offset = @top_margin + legend_top_margin
        else
          current_x_offset = @legend_left_margin
          current_y_offset = @original_rows + legend_top_margin
        end

        @legend_labels.each_with_index do |legend_label, index|
          # Draw label
          label = truncate_legend_label(legend_label)
          text_renderer = Gruff::Renderer::Text.new(renderer, label, font: @legend_font)
          x_offset = current_x_offset + (legend_square_width * 1.7)
          text_renderer.add_to_render_queue(@raw_columns, 1.0, x_offset, current_y_offset, Magick::WestGravity)

          # Now draw box with color of this dataset
          rect_renderer = Gruff::Renderer::Rectangle.new(renderer, color: store.data[index].color)
          rect_renderer.render(current_x_offset,
                               current_y_offset - legend_square_width / 2.0,
                               current_x_offset + legend_square_width,
                               current_y_offset + legend_square_width / 2.0)

          current_y_offset += calculate_line_height
        end
      end

      ##
      # Shorten long labels so they will fit on the canvas.
      #
      #   Department of Hu...

      def truncate_legend_label(label)
        truncated_label = label.to_s

        font = @legend_font.dup
        font.size = scale_fontsize(font.size)
        max_width = @columns - @legend_left_margin - @right_margin
        while calculate_width(font, truncated_label) > max_width && truncated_label.length > 1
          truncated_label = truncated_label[0..truncated_label.length - 2]
        end
        truncated_label + (truncated_label.length < label.to_s.length ? '...' : '')
      end
    end
  end
end

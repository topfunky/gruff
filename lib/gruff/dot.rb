# frozen_string_literal: true

require 'gruff/base'

#
# Graph with dots and labels along a vertical access.
# see: 'Creating More Effective Graphs' by Robbins
#
# Here's how to set up a Gruff::Dot.
#
#   g = Gruff::Dot.new
#   g.title = 'Dot Graph'
#   g.data :Art, [0, 5, 8, 15]
#   g.data :Philosophy, [10, 3, 2, 8]
#   g.data :Science, [2, 15, 8, 11]
#   g.write('dot.png')
#
class Gruff::Dot < Gruff::Base
  def draw
    @has_left_labels = true
    super

    return unless data_given?

    # Setup spacing.
    #
    spacing_factor = 1.0

    items_width = @graph_height / column_count.to_f
    item_width = items_width * spacing_factor / store.length
    padding = (items_width * (1 - spacing_factor)) / 2

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        x_pos = @graph_left + (data_point * @graph_width)
        y_pos = @graph_top + (items_width * point_index) + padding + (items_width.to_f / 2.0).round

        if row_index == 0
          Gruff::Renderer::Line.new(color: @marker_color).render(@graph_left, y_pos, @graph_left + @graph_width, y_pos)
        end

        Gruff::Renderer::Circle.new(color: data_row.color).render(x_pos, y_pos, x_pos + (item_width.to_f / 3.0).round, y_pos)

        draw_label(y_pos, point_index)
      end
    end

    Gruff::Renderer.finish
  end

protected

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers
    return if @hide_line_markers

    # Draw horizontal line markers and annotate with numbers
    if @y_axis_increment
      increment = @y_axis_increment
      number_of_lines = (@spread / @y_axis_increment).to_i
    else
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
        @marker_count ||= 5
      end
      # TODO: Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
      increment = (@spread > 0 && @marker_count > 0) ? significant(@spread / @marker_count) : 1
      number_of_lines = @marker_count
    end

    (0..number_of_lines).each do |index|
      marker_label = minimum_value + index * increment
      x = @graph_left + (marker_label - minimum_value) * @graph_width / @spread
      Gruff::Renderer::Line.new(color: @marker_color).render(x, @graph_bottom, x, @graph_bottom + 0.5 * LABEL_MARGIN)

      unless @hide_line_numbers
        label = label(marker_label, increment)
        text_renderer = Gruff::Renderer::Text.new(label, font: @font, size: @marker_font_size, color: @font_color)
        text_renderer.render(0, 0, x, @graph_bottom + (LABEL_MARGIN * 2.0), Magick::CenterGravity)
      end
    end
  end

  ##
  # Draw on the Y axis instead of the X

  def draw_label(y_offset, index)
    draw_unique_label(index) do
      text_renderer = Gruff::Renderer::Text.new(@labels[index], font: @font, size: @marker_font_size, color: @font_color)
      text_renderer.render(@graph_left - LABEL_MARGIN * 2, 1.0, 0.0, y_offset, Magick::EastGravity)
    end
  end
end

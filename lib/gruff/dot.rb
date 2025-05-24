# frozen_string_literal: true

# rbs_inline: enabled

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
  # Prevent drawing of column labels below a stacked bar graph.  Default is +false+.
  attr_writer :hide_labels #: bool

  # @rbs target_width: (String | Float | Integer)
  # @rbs return: void
  def initialize(target_width = DEFAULT_TARGET_WIDTH)
    super
    @has_left_labels = true
    @dot_style = 'circle'
  end

private

  def initialize_attributes
    super
    @hide_labels = false
  end

  # @rbs return: bool
  def hide_labels?
    @hide_labels
  end

  # @rbs return: bool
  def hide_left_label_area?
    hide_labels? && @y_axis_label.nil?
  end

  # @rbs return: bool
  def hide_bottom_label_area?
    @hide_line_markers && @x_axis_label.nil? && @legend_at_bottom == false
  end

  def draw_graph
    # Setup spacing.
    #
    spacing_factor = 1.0

    items_width = @graph_height / column_count
    item_width = items_width * spacing_factor / store.length
    padding = (items_width * (1 - spacing_factor)) / 2.0

    store.norm_data.each_with_index do |data_row, row_index|
      data_row.points.each_with_index do |data_point, point_index|
        x_pos = @graph_left + (data_point.to_f * @graph_width)
        y_pos = @graph_top + (items_width * point_index) + padding + (items_width / 2.0)

        if row_index == 0
          Gruff::Renderer::Line.new(renderer, color: @marker_color).render(@graph_left, y_pos, @graph_left + @graph_width, y_pos)
        end
        next if data_point.nil?

        Gruff::Renderer::Dot.new(renderer, @dot_style, color: data_row.color).render(x_pos, y_pos, item_width / 3.0)

        draw_label(y_pos, point_index)
      end
    end
  end

  # Instead of base class version, draws vertical background lines and label
  def draw_line_markers
    return if @hide_line_markers

    (0..marker_count).each do |index|
      marker_label = (BigDecimal(index.to_s) * BigDecimal(@increment.to_s)) + BigDecimal(minimum_value.to_s)
      x = @graph_left + ((marker_label - minimum_value) * @graph_width / @spread)
      draw_marker_vertical_line(x, tick_mark_mode: true)

      unless @hide_line_numbers
        label = y_axis_label(marker_label, @increment)
        y = @graph_bottom + @label_margin + (labels_caps_height / 2.0) + 5 # 5px offset for tick_mark_mode
        text_renderer = Gruff::Renderer::Text.new(renderer, label, font: @marker_font)
        text_renderer.add_to_render_queue(0, 0, x, y, Magick::CenterGravity)
      end
    end
  end

  ##
  # Draw on the Y axis instead of the X

  # @rbs y_offset: Float | Integer
  # @rbs index: Integer
  def draw_label(y_offset, index)
    draw_unique_label(index) do
      draw_label_at(@graph_left - @label_margin, 1.0, 0.0, y_offset, @labels[index], gravity: Magick::EastGravity)
    end
  end
end

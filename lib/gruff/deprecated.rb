
##
# A mixin for methods that need to be deleted or have been
# replaced by cleaner code.

module Gruff
  module Deprecated

    def scale_measurements
      setup_graph_measurements
    end

    def total_height
      @rows + 10
    end

    def graph_top
      @graph_top * @scale
    end

    def graph_height
      @graph_height * @scale
    end

    def graph_left
      @graph_left * @scale
    end

    def graph_width
      @graph_width * @scale
    end

    # TODO Should be calculate_graph_height
    # def setup_graph_height
    #   @graph_height = @graph_bottom - @graph_top
    # end

  end
end

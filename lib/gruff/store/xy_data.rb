module Gruff
  class Store
    class XYData < Struct.new(:label, :y_points, :color, :x_points)
      def points
        y_points
      end
    end
  end
end

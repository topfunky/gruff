# frozen_string_literal: true

module Gruff
  class Store
    class XYData < Struct.new(:label, :y_points, :color, :x_points)
      def points
        y_points
      end

      def columns
        y_points.length
      end

      def min
        y_points.compact.min
      end

      def max
        y_points.compact.max
      end
    end
  end
end

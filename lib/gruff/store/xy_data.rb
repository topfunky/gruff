# frozen_string_literal: true

module Gruff
  class Store
    class XYData < Struct.new(:label, :y_points, :color, :x_points)
      def initialize(label, y_points, color, x_points = nil)
        self.label = label
        self.y_points = Array(y_points)
        self.color = color
        self.x_points = Array(x_points) if x_points
      end

      def points
        y_points
      end

      def coordinates
        x = x_points || Array.new(y_points.length)
        x.zip(y_points)
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

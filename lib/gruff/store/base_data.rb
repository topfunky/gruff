# frozen_string_literal: true

module Gruff
  class Store
    class BaseData < Struct.new(:label, :points, :color)
      def initialize(label, points, color)
        self.label = label
        self.points = Array(points)
        self.color = color
      end

      def columns
        points.length
      end

      def min
        points.compact.min
      end

      def max
        points.compact.max
      end
    end
  end
end

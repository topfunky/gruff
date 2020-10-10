# frozen_string_literal: true

module Gruff
  class Store
    # @private
    class XYData < Struct.new(:label, :y_points, :color, :x_points)
      def initialize(label, y_points, color, x_points = nil)
        x_points = Array(x_points) if x_points
        super(label.to_s, Array(y_points), color, x_points)
      end

      def x_points
        self[:x_points] || Array.new(y_points.length)
      end

      def coordinates
        x_points.zip(y_points)
      end

      def empty?
        y_points.empty?
      end

      def columns
        y_points.length
      end

      def min
        y_points.compact.min
      end
      alias min_y min

      def max
        y_points.compact.max
      end
      alias max_y max

      def min_x
        x_points.compact.min
      end

      def max_x
        x_points.compact.max
      end

      def normalize(minimum_x:, minimum_y:, spread_x:, spread_y:)
        norm_x_points = x_points.map do |x|
          x.nil? ? nil : (x.to_f - minimum_x.to_f) / spread_x
        end
        norm_y_points = y_points.map do |y|
          y.nil? ? nil : (y.to_f - minimum_y.to_f) / spread_y
        end

        self.class.new(label, norm_y_points, color, norm_x_points)
      end
    end
  end
end

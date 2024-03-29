# frozen_string_literal: true

module Gruff
  class Store
    # @private
    class XYData < Struct.new(:label, :x_points, :y_points, :color)
      def initialize(label, x_points, y_points, color)
        y_points = Array(y_points)
        x_points = x_points ? Array(x_points) : Array.new(y_points.length)
        raise ArgumentError, 'x_points.length != y_points.length!' if x_points.length != y_points.length

        super(label.to_s, x_points, y_points, color)
      end

      alias points y_points

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

        self.class.new(label, norm_x_points, norm_y_points, color)
      end
    end
  end
end

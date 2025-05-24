# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  class Store
    # @private
    class XYData
      attr_accessor :label #: String
      attr_accessor :x_points #: Array[nil | Float | Integer]
      attr_accessor :y_points #: Array[nil | Float | Integer]
      attr_accessor :color #: String

      # @rbs label: String | Symbol
      # @rbs x_points: Array[nil | Float | Integer] | nil
      # @rbs y_points: Array[nil | Float | Integer] | nil
      # @rbs color: String
      def initialize(label, x_points, y_points, color)
        y_points = Array(y_points)
        x_points = x_points ? Array(x_points) : Array.new(y_points.length)
        raise ArgumentError, 'x_points.length != y_points.length!' if x_points.length != y_points.length

        @label = label.to_s
        @x_points = x_points
        @y_points = y_points
        @color = color
      end

      alias points y_points

      # @rbs return: Array[[Float | Integer | nil, Float | Integer | nil]]
      def coordinates
        x_points.zip(y_points)
      end

      def coordinate_and_pointsizes
        raise NotImplementedError, 'This method is not implemented for XYData'
      end

      # @rbs return: bool
      def empty?
        y_points.empty?
      end

      # @rbs return: Integer
      def columns
        y_points.length
      end

      # @rbs return: Float | Integer
      def min
        y_points.compact.min
      end
      alias min_y min

      # @rbs return: Float | Integer
      def max
        y_points.compact.max
      end
      alias max_y max

      # @rbs return: Float | Integer
      def min_x
        x_points.compact.min
      end

      # @rbs return: Float | Integer
      def max_x
        x_points.compact.max
      end

      # @rbs minimum_x: Float | Integer
      # @rbs minimum_y: Float | Integer
      # @rbs spread_x: Float | Integer
      # @rbs spread_y: Float | Integer
      # @rbs return: Gruff::Store::XYData
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

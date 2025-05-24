# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  class Store
    # @private
    class BasicData
      attr_accessor :label #: String | Symbol
      attr_accessor :points #: Array[nil | Float | Integer]
      attr_accessor :color #: String

      # @rbs label: String | Symbol
      # @rbs points: Array[nil | Float | Integer] | nil
      # @rbs color: String
      def initialize(label, points, color)
        @label = label.to_s
        @points = Array(points)
        @color = color
      end

      alias x_points points

      def y_points
        raise NotImplementedError, 'x_points is not implemented for BasicData'
      end

      def coordinates
        raise NotImplementedError, 'This method is not implemented for BasicData'
      end

      def coordinate_and_pointsizes
        raise NotImplementedError, 'This method is not implemented for BasicData'
      end

      # @rbs return: bool
      def empty?
        points.empty?
      end

      # @rbs return: Integer
      def columns
        points.length
      end

      # @rbs return: Float | Integer
      def min
        points.compact.min
      end
      alias min_x min

      # @rbs return: Float | Integer
      def max
        points.compact.max
      end
      alias max_x max

      # @rbs minimum: Float | Integer
      # @rbs spread: Float | Integer
      # @rbs return: Gruff::Store::BasicData
      def normalize(minimum:, spread:)
        norm_points = points.map do |point|
          point.nil? ? nil : (point.to_f - minimum.to_f) / spread
        end

        self.class.new(label, norm_points, color)
      end
    end
  end
end

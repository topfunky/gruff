# frozen_string_literal: true

module Gruff
  class Store
    # @private
    class BaseData < Struct.new(:label, :points, :color)
      def initialize(label, points, color)
        super(label.to_s, Array(points), color)
      end

      def empty?
        points.empty?
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

      def normalize(minimum:, spread:)
        norm_points = points.map do |point|
          point.nil? ? nil : (point.to_f - minimum.to_f) / spread
        end

        self.class.new(label, norm_points, color)
      end
    end
  end
end

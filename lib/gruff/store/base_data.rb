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

      def normalize(args = {})
        norm_points = points.map do |point|
          point.nil? ? nil : (point.to_f - args[:minimum].to_f) / args[:spread]
        end

        self.class.new(label, norm_points, color)
      end
    end
  end
end

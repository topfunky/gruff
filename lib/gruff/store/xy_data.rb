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

      def x_points
        self[:x_points] || Array.new(y_points.length)
      end

      def coordinates
        x_points.zip(y_points)
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

      def normalize(args = {})
        norm_x_points = x_points.map do |x|
          x.nil? ? nil : (x.to_f - args[:minimum_x].to_f) / args[:spread_x]
        end
        norm_y_points = y_points.map do |y|
          y.nil? ? nil : (y.to_f - args[:minimum_y].to_f) / args[:spread_y]
        end

        self.class.new(label, norm_y_points, color, norm_x_points)
      end
    end
  end
end

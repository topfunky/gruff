# frozen_string_literal: true

module Gruff
  class Store
    class CustomData < Struct.new(:label, :points, :color, :custom)
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

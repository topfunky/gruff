# frozen_string_literal: true

module Gruff
  class Store
    attr_reader :data, :norm_data

    def initialize(data_class)
      @data_class = data_class
      @data = []
    end

    def add(name, data_points, color)
      @data << @data_class.new(name, Array(data_points), color)
    end

    def empty?
      @data.empty?
    end

    def length
      @data.length
    end

    def minmax
      @minmax ||= begin
        unless @data.empty?
          points = @data.map(&:points).flatten.compact
          points.minmax
        end
      end
    end

    def columns
      @columns ||=
        @data.empty? ? 0 : @data.map { |data_row| data_row.points.length }.max
    end

    def sort!
      @data = @data.sort_by { |a| -a.points.reduce(0) { |acc, elem| acc + elem.to_f } }
    end

    def reverse!
      @data.reverse!
    end

    def set_colors!(colors, index)
      @data.each do |data_row|
        data_row.color ||= begin
          index = (index + 1) % colors.length
          colors[index - 1]
        end
      end
    end
  end
end

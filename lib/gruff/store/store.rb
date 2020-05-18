# frozen_string_literal: true

module Gruff
  class Store
    attr_reader :data, :norm_data

    def initialize(data_class)
      @data_class = data_class
      @data = []
      @norm_data = []
      @normalized = false
    end

    def add(*args)
      @data << @data_class.new(*args)
    end

    def normalize(args = {})
      unless @normalized
        @data.each do |data_row|
          @norm_data << data_row.normalize(args)
        end

        @normalized = true
      end
    end

    def empty?
      @data.empty?
    end

    def length
      @data.length
    end

    def columns
      @columns ||= @data.empty? ? 0 : @data.map(&:columns).max
    end

    def min
      @min ||= @data.map(&:min).compact.min
    end
    alias min_y min

    def max
      @max ||= @data.map(&:max).compact.max
    end
    alias max_y max

    def min_x
      @min_x ||= @data.map(&:min_x).compact.min
    end

    def max_x
      @max_x ||= @data.map(&:max_x).compact.max
    end

    def sort_data!
      @data = @data.sort_by { |a| -a.points.reduce(0) { |acc, elem| acc + elem.to_f } }
    end

    def sort_norm_data!
      @norm_data = @norm_data.sort_by { |a| -a.points.reduce(0) { |acc, elem| acc + elem.to_f } }
    end

    def reverse!
      @data.reverse!
    end

    def stack!
      stacked_values = Array.new(columns, 0)
      @data.each do |data_row|
        data_row.points.each_with_index do |value, index|
          stacked_values[index] += value
        end
        data_row.points = stacked_values.dup
      end
    end

    def set_colors!(colors)
      index = 0
      @data.each do |data_row|
        data_row.color ||= begin
          index = (index + 1) % colors.length
          colors[index - 1]
        end
      end
    end
  end
end

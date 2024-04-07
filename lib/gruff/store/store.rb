# frozen_string_literal: true

module Gruff
  # @private
  class Store
    attr_reader :data

    def initialize(data_class)
      @data_class = data_class
      @data = []
    end

    def add(*args)
      @data << @data_class.new(*args)
    end

    def norm_data
      @norm_data || []
    end

    def normalize(**keywords)
      @norm_data = @data.map { |data_row| data_row.normalize(**keywords) }
    end

    def empty?
      @data.all?(&:empty?)
    end

    def length
      @data.length
    end

    def columns
      @columns ||= @data.empty? ? 0 : @data.map(&:columns).max
    end

    def min
      @min ||= @data.filter_map(&:min).min
    end
    alias min_y min

    def max
      @max ||= @data.filter_map(&:max).max
    end
    alias max_y max

    def min_x
      @min_x ||= @data.filter_map(&:min_x).min
    end

    def max_x
      @max_x ||= @data.filter_map(&:max_x).max
    end

    def sort_data!
      @data = @data.sort_by { |a| -a.points.sum(&:to_f) }
    end

    def sort_norm_data!
      @norm_data = @norm_data.sort_by { |a| -a.points.sum(&:to_f) }
    end

    def reverse!
      @data.reverse!
    end

    def change_colors(colors)
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

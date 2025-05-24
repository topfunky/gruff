# frozen_string_literal: true

# rbs_inline: enabled

module Gruff
  # @private
  class Store
    attr_reader :data #: Array[Gruff::Store::BasicData | Gruff::Store::XYData | Gruff::Store::XYPointsizeData]

    # @rbs return: void
    def initialize(data_class)
      @data_class = data_class
      @data = []
    end

    def add(*args)
      @data << @data_class.new(*args)
    end

    # @rbs return: Array[Gruff::Store::BasicData | Gruff::Store::XYData | Gruff::Store::XYPointsizeData]
    def norm_data
      @norm_data || []
    end

    def normalize(**keywords)
      @norm_data = @data.map { |data_row| data_row.normalize(**keywords) } # steep:ignore
    end

    # @rbs return: bool
    def empty?
      @data.all?(&:empty?)
    end

    # @rbs return: Integer
    def length
      @data.length
    end

    # @rbs return: Integer
    def columns
      @columns ||= @data.empty? ? 0 : @data.map(&:columns).max
    end

    # @rbs return: Float | Integer
    def min
      @min ||= @data.filter_map(&:min).min
    end
    alias min_y min

    # @rbs return: Float | Integer
    def max
      @max ||= @data.filter_map(&:max).max
    end
    alias max_y max

    # @rbs return: Float | Integer
    def min_x
      @min_x ||= @data.filter_map(&:min_x).min
    end

    # @rbs return: Float | Integer
    def max_x
      @max_x ||= @data.filter_map(&:max_x).max
    end

    def sort_data!
      @data = @data.sort_by { |a| -a.points.sum(&:to_f) }
    end

    def sort_norm_data!
      @norm_data = @norm_data.sort_by { |a| -a.points.sum(&:to_f) }
    end

    # @rbs return: Array[Gruff::Store::BasicData | Gruff::Store::XYData | Gruff::Store::XYPointsizeData]
    def reverse!
      @data.reverse!
    end

    # @rbs colors: Array[String]
    def change_colors(colors)
      index = 0
      @data.each do |data_row|
        data_row.color ||= begin # steep:ignore
          index = (index + 1) % colors.length
          colors[index - 1]
        end
      end
    end
  end
end

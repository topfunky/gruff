# frozen_string_literal: true

module Gruff
  class Store
    attr_reader :data, :norm_data
    attr_reader :data_class

    def initialize(data_class)
      @data_class = data_class
      @data = []
      @norm_data = []
    end

    def add(*args)
      @data << @data_class.new(*args)
    end

    def normalize(args = {})
      @data.each do |raw_data|
        @norm_data << raw_data.normalize(args)
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
      @min ||= begin
        unless @data.empty?
          @data.map(&:min).min
        end
      end
    end

    def max
      @max ||= begin
        unless @data.empty?
          @data.map(&:max).max
        end
      end
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

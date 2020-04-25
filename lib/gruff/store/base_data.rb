# frozen_string_literal: true

module Gruff
  class Store
    class BaseData < Struct.new(:label, :points, :color)
    end
  end
end

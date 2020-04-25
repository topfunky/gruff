# frozen_string_literal: true

module Gruff
  class Store
    class CustomData < Struct.new(:label, :points, :color, :custom)
    end
  end
end

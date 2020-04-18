module Gruff
  class Store
    class CustomData < Struct.new(:label, :points, :color, :custom)
    end
  end
end

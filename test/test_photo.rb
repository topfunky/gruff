#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"

class TestGruffPhotoBar < GruffTestCase

#   def setup
#     @datasets = [
#       [:Jimmy, [25, 36, 86, 39]],
#       [:Charles, [80, 54, 67, 54]],
# #      [:Charity, [0, nil, 100, 90]],
#       ]
#   end
# 
#   def test_bar_graph
#     bar_graph_sized
#     bar_graph_sized(400)
#   end
# 
# 
# protected
# 
#   def bar_graph_sized(size=800)
#     g = Gruff::PhotoBar.new(size)
#     g.title = "Photo Bar Graph Test #{size}px"
#     g.labels = {
#       0 => '5/6', 
#       1 => '5/15', 
#       2 => '5/24', 
#       3 => '5/30', 
#     }
#     @datasets.each do |data|
#       g.data(*data)
#     end
# 
#     g.theme = 'plastik'
# 
#     g.write("test/output/photo_plastik_#{size}.png")    
#   end

end

class <%= controller_class_name %>Controller < ApplicationController

  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)

  def show
    g = Gruff::Line.new
    # Uncomment to use your own theme or font
    # See http://colourlovers.com or http://www.firewheeldesign.com/widgets/ for color ideas
#     g.theme = {
#       :colors => ['#663366', '#cccc99', '#cc6633', '#cc9966', '#99cc99'],
#       :marker_color => 'white',
#       :background_colors => ['black', '#333333']
#     }
#     g.font = File.expand_path('artwork/fonts/VeraBd.ttf', RAILS_ROOT)

    g.title = "Gruff-o-Rama"
    
    g.data("Apples", [1, 2, 3, 4, 4, 3])
    g.data("Oranges", [4, 8, 7, 9, 8, 9])
    g.data("Watermelon", [2, 3, 1, 5, 6, 8])
    g.data("Peaches", [9, 9, 10, 8, 7, 9])

    g.labels = {0 => '2004', 2 => '2005', 4 => '2006'}

    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  end

end

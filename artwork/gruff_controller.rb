
# Handles requests for gruff graphs.
#
# You shouldn't need to edit or extend this, but you can read
# the documentation for GruffHelper to see how to call it from
# another view.
#
# AUTHOR
# Carlos Villela [mailto:cv@lixo.org]
# Geoffrey Grosenbach[mailto:boss@topfunky.com]
#
# http://lixo.org
# http://topfunky.com
#
require_gem 'gruff'

class GruffController < ApplicationController
  layout nil

  def index
    opts = @session['gruff_opts']
    data = @session['gruff_data']

    raise "No Gruff data or options set in the session" if data.nil? or opts.nil?

    g = Gruff::Line.new(475)
    g.title = opts[:title]
    g.labels = opts[:labels]
    g.theme_37signals

    data.each_pair {|k,v| g.data(k, v) }

    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  end

end

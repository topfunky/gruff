# frozen_string_literal: true

require 'rmagick'

require_relative 'gruff/patch/rmagick'
require_relative 'gruff/patch/string'
require_relative 'gruff/renderer/renderer'
require_relative 'gruff/store/store'
require_relative 'gruff/font'
require_relative 'gruff/base'
require_relative 'gruff/version'

##
# = Gruff. Graphs.
#
module Gruff
  # @private
  def self.libpath(path)
    File.join(__dir__, 'gruff', path)
  end

  autoload :BarConversion, Gruff.libpath('helper/bar_conversion')
  autoload :BarValueLabel, Gruff.libpath('helper/bar_value_label')
  class Base
    autoload :StackedMixin, Gruff.libpath('helper/stacked_mixin')
  end

  autoload :AccumulatorBar, Gruff.libpath('accumulator_bar')
  autoload :Area, Gruff.libpath('area')
  autoload :Bar, Gruff.libpath('bar')
  autoload :Bezier, Gruff.libpath('bezier')
  autoload :BoxPlot, Gruff.libpath('box_plot')
  autoload :Bullet, Gruff.libpath('bullet')
  autoload :Dot, Gruff.libpath('dot')
  autoload :Histogram, Gruff.libpath('histogram')
  autoload :Line, Gruff.libpath('line')
  autoload :Net, Gruff.libpath('net')
  autoload :Pie, Gruff.libpath('pie')
  autoload :Scatter, Gruff.libpath('scatter')
  autoload :SideBar, Gruff.libpath('side_bar')
  autoload :SideStackedBar, Gruff.libpath('side_stacked_bar')
  autoload :Spider, Gruff.libpath('spider')
  autoload :StackedArea, Gruff.libpath('stacked_area')
  autoload :StackedBar, Gruff.libpath('stacked_bar')

  autoload :Layer, Gruff.libpath('scene')
  autoload :Themes, Gruff.libpath('themes')

  class Renderer
    autoload :Bezier, Gruff.libpath('renderer/bezier')
    autoload :Circle, Gruff.libpath('renderer/circle')
    autoload :DashLine, Gruff.libpath('renderer/dash_line')
    autoload :Dot, Gruff.libpath('renderer/dot')
    autoload :Ellipse, Gruff.libpath('renderer/ellipse')
    autoload :Line, Gruff.libpath('renderer/line')
    autoload :Polygon, Gruff.libpath('renderer/polygon')
    autoload :Polyline, Gruff.libpath('renderer/polyline')
    autoload :Rectangle, Gruff.libpath('renderer/rectangle')
    autoload :Text, Gruff.libpath('renderer/text')
  end

  class Store
    autoload :BasicData, Gruff.libpath('store/basic_data')
    autoload :CustomData, Gruff.libpath('store/custom_data')
    autoload :XYData, Gruff.libpath('store/xy_data')
  end

  module Mini
    autoload :Bar, Gruff.libpath('mini/bar')
    autoload :Legend, Gruff.libpath('mini/legend')
    autoload :Pie, Gruff.libpath('mini/pie')
    autoload :SideBar, Gruff.libpath('mini/side_bar')
  end
end

require 'gruff/version'

# Extra full path added to fix loading errors on some installations.

%w(
  themes
  axis
  base
  area
  bar
  bar_n_line
  bezier
  bullet
  dot
  line
  net
  pie
  scatter
  spider
  stacked_area
  stacked_bar
  side_stacked_bar
  side_bar
  accumulator_bar

  scene

  mini/legend
  mini/bar
  mini/pie
  mini/side_bar
).each do |filename|
  require "gruff/#{filename}"
end

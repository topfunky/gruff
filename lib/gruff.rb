# Extra full path added to fix loading errors on some installations.

%w(
  base
  area
  bar
  line
  pie
  spider
  net
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
  require File.dirname(__FILE__) + "/gruff/#{filename}"
end

# TODO bullet
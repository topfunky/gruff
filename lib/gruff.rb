# frozen_string_literal: true

require 'gruff/version'

# Extra full path added to fix loading errors on some installations.

%w[
  patch/rmagick
  patch/string

  themes
  base
  area
  bar
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

  store/store
  store/base_data
  store/custom_data
  store/xy_data

  mini/legend
  mini/bar
  mini/pie
  mini/side_bar
].each do |filename|
  require "gruff/#{filename}"
end

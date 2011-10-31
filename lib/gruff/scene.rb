
require "observer"
require File.dirname(__FILE__) + '/base'

##
# A scene is a non-linear graph that assembles layers together to tell a story.
# Layers are folders with appropriately named files (see below). You can group 
# layers and control them together or just set their values individually.
#
# Examples:
#
# * A city scene that changes with the time of day and the weather conditions.
# * A traffic map that shows red lines on streets that are crowded and green on free-flowing ones.
#
# Usage:
# 
#  g = Gruff::Scene.new("500x100", "path/to/city_scene_directory")
#
#  # Define order of layers, back to front
#  g.layers = %w(background haze sky clouds)
#
#  # Define groups that will be controlled by the same input
#  g.weather_group = %w(clouds)
#  g.time_group = %w(background sky)
#
#  # Set values for the layers or groups
#  g.weather = "cloudy"
#  g.time = Time.now
#  g.haze = true
#
#  # Write the final graph to disk
#  g.write "hazy_daytime_city_scene.png"
#
#
# There are several rules that will magically select a layer when possible.
#
# * Numbered files will be selected according to the closest value that is less than the input value.
# * 'true.png' and 'false.png' will be used as booleans.
# * Other named files will be used if the input matches the filename (without the filetype extension).
# * If there is a file named 'default.png', it will be used unless other input values are set for the corresponding layer.

class Gruff::Scene < Gruff::Base
    
  # An array listing the foldernames that will be rendered, from back to front.
  #
  #  g.layers = %w(sky clouds buildings street people)
  #
  attr_reader :layers

  def initialize(target_width, base_dir)
    @base_dir = base_dir
    @groups = {}
    @layers = []    
    super target_width
  end

  def draw
    # Join all the custom paths and filter out the empty ones
    image_paths = @layers.map { |layer| layer.path }.select { |path| !path.empty? }
    images = Magick::ImageList.new(*image_paths)
    @base_image = images.flatten_images
  end

  def layers=(ordered_list)
    ordered_list.each do |layer_name|
      @layers << Gruff::Layer.new(@base_dir, layer_name)
    end
  end

  # Group layers to input values
  #
  #  g.weather_group = ["sky", "sea", "clouds"]
  #
  # Set input values
  #
  #  g.weather = "cloudy"
  #
  def method_missing(method_name, *args)
    case method_name.to_s
    when /^(\w+)_group=$/
      add_group $1, *args
      return
    when /^(\w+)=$/
      set_input $1, args.first
      return
    end
    super
  end

private

  def add_group(input_name, layer_names)
    @groups[input_name] = Gruff::Group.new(input_name, @layers.select { |layer| layer_names.include?(layer.name) })
  end

  def set_input(input_name, input_value)
    if not @groups[input_name].nil?
      @groups[input_name].send_updates(input_value)
    else
      if chosen_layer = @layers.detect { |layer| layer.name == input_name }
        chosen_layer.update input_value
      end
    end
  end
  
end


class Gruff::Group

  include Observable
  attr_reader :name

  def initialize(folder_name, layers)
    @name = folder_name
    layers.each do |layer|
      layer.observe self
    end
  end
  
  def send_updates(value)
    changed
    notify_observers value
  end
  
end


class Gruff::Layer
  
  attr_reader :name
  
  def initialize(base_dir, folder_name)
    @base_dir = base_dir.to_s
    @name = folder_name.to_s
    @filenames = Dir.open(File.join(base_dir, folder_name)).entries.select { |file| file =~ /^[^.]+\.png$/ }.sort
    @selected_filename = select_default
  end
  
  # Register this layer so it receives updates from the group
  def observe(obj)
    obj.add_observer self
  end
  
  # Choose the appropriate filename for this layer, based on the input
  def update(value)
    @selected_filename =  case value.to_s
                          when /^(true|false)$/
                            select_boolean value
                          when /^(\w|\s)+$/
                            select_string value
                          when /^-?(\d+\.)?\d+$/
                            select_numeric value
                          when /(\d\d):(\d\d):\d\d/
                            select_time "#{$1}#{$2}"
                          else
                            select_default
                          end
    # Finally, try to use 'default' if we're still blank
    @selected_filename ||= select_default
  end

  # Returns the full path to the selected image, or a blank string
  def path
    unless @selected_filename.nil? || @selected_filename.empty?
      return File.join(@base_dir, @name, @selected_filename)
    end
    ''
  end

private

  # Match "true.png" or "false.png"
  def select_boolean(value)
    file_exists_or_blank value.to_s
  end

  # Match -5 to _5.png
  def select_numeric(value)
    file_exists_or_blank value.to_s.gsub('-', '_')
  end
  
  def select_time(value)
    times = @filenames.map { |filename| filename.gsub('.png', '') }
    times.each_with_index do |time, index|
      if (time > value) && (index > 0)
        return "#{times[index - 1]}.png"
      end
    end
    return "#{times.last}.png"
  end
  
  # Match "partly cloudy" to "partly_cloudy.png"
  def select_string(value)
    file_exists_or_blank value.to_s.gsub(' ', '_')
  end
  
  def select_default
    @filenames.include?("default.png") ? "default.png" : ''
  end

  # Returns the string "#{filename}.png", if it exists.
  #
  # Failing that, it returns default.png, or '' if that doesn't exist.
  def file_exists_or_blank(filename)
    @filenames.include?("#{filename}.png") ? "#{filename}.png" : select_default
  end
  
end

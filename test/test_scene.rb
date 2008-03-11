#!/usr/bin/ruby

require File.dirname(__FILE__) + "/gruff_test_case"
require 'yaml'

class LayerStub < Gruff::Layer; attr_reader :base_dir, :filenames, :selected_filename; end

class TestGruffScene < GruffTestCase

  def test_hazy
    g = setup_scene
    g.weather = "cloudy"
    g.haze = true
    g.time = Time.mktime(2006, 7, 4, 4, 35)
    g.write "test/output/scene_hazy_night.png"
  end

  def test_stormy_night
    g = setup_scene
    g.weather = "stormy"
    g.time = Time.mktime(2006, 7, 4, 0, 0)
    g.write "test/output/scene_stormy_night.png"
  end


  def test_not_hazy
    g = setup_scene
    g.weather = "cloudy"
    g.haze = false
    g.time = Time.mktime(2006, 7, 4, 6, 00)
    g.write "test/output/scene_not_hazy_day.png"
  end

  def test_partly_cloudy
    g = setup_scene
    g.weather = "partly cloudy"
    g.haze = false
    g.time = Time.mktime(2006, 7, 4, 13, 00)
    g.write "test/output/scene_partly_cloudy_day.png"
  end


  def test_stormy_day
    g = setup_scene
    g.weather = "stormy"
    g.haze = false
    g.time = Time.mktime(2006, 7, 4, 8, 00)
    g.write "test/output/scene_stormy_day.png"
  end


  def test_layer
    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "clouds")
    assert_equal %w(cloudy.png partly_cloudy.png stormy.png), l.filenames
    
    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "grass")
    assert_equal 'default.png', l.selected_filename
    
    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 12, 35) # 12:35, July 4, 2006
    assert_equal '1200.png', l.selected_filename

    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 0, 0) # 00:00, July 4, 2006
    assert_equal '0000.png', l.selected_filename

    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 23, 35) # 23:35, July 4, 2006
    assert_equal '2000.png', l.selected_filename

    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 0, 1) # 00:01, July 4, 2006
    assert_equal '0000.png', l.selected_filename

    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 2, 0) # 02:00, July 4, 2006
    assert_equal '0200.png', l.selected_filename

    l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "sky")
    l.update Time.mktime(2006, 7, 4, 4, 00) # 04:00, July 4, 2006
    assert_equal '0400.png', l.selected_filename
    
    # TODO Need number_sample folder
    # l = LayerStub.new(File.expand_path("../assets/city_scene", File.dirname(__FILE__)), "number_sample")
    # assert_equal %w(1.png 2.png default.png), l.filenames
    # l.update 3
    # assert_equal 'default.png', l.selected_filename
  end

private

  def setup_scene
    g = Gruff::Scene.new("500x100", File.expand_path("../assets/city_scene", File.dirname(__FILE__)) )
    g.layers = %w(background haze sky clouds)
    g.weather_group = %w(clouds)
    g.time_group = %w(background sky)
    g    
  end

end

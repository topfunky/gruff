Gem::Specification.new do |s|
  s.name = %q{gruff}
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Geoffrey Grosenbach"]
  s.date = %q{2009-01-14}
  s.description = %q{Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.}
  s.email = %q{boss@topfunky.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "MIT-LICENSE", "Manifest.txt", "README.txt", "Rakefile", "assets/bubble.png", "assets/city_scene/background/0000.png", "assets/city_scene/background/0600.png", "assets/city_scene/background/2000.png", "assets/city_scene/clouds/cloudy.png", "assets/city_scene/clouds/partly_cloudy.png", "assets/city_scene/clouds/stormy.png", "assets/city_scene/grass/default.png", "assets/city_scene/haze/true.png", "assets/city_scene/number_sample/1.png", "assets/city_scene/number_sample/2.png", "assets/city_scene/number_sample/default.png", "assets/city_scene/sky/0000.png", "assets/city_scene/sky/0200.png", "assets/city_scene/sky/0400.png", "assets/city_scene/sky/0600.png", "assets/city_scene/sky/0800.png", "assets/city_scene/sky/1000.png", "assets/city_scene/sky/1200.png", "assets/city_scene/sky/1400.png", "assets/city_scene/sky/1500.png", "assets/city_scene/sky/1700.png", "assets/city_scene/sky/2000.png", "assets/pc306715.jpg", "assets/plastik/blue.png", "assets/plastik/green.png", "assets/plastik/red.png", "init.rb", "lib/gruff.rb", "lib/gruff/accumulator_bar.rb", "lib/gruff/area.rb", "lib/gruff/bar.rb", "lib/gruff/bar_conversion.rb", "lib/gruff/base.rb", "lib/gruff/bullet.rb", "lib/gruff/deprecated.rb", "lib/gruff/dot.rb", "lib/gruff/line.rb", "lib/gruff/mini/bar.rb", "lib/gruff/mini/legend.rb", "lib/gruff/mini/pie.rb", "lib/gruff/mini/side_bar.rb", "lib/gruff/net.rb", "lib/gruff/photo_bar.rb", "lib/gruff/pie.rb", "lib/gruff/scene.rb", "lib/gruff/side_bar.rb", "lib/gruff/side_stacked_bar.rb", "lib/gruff/spider.rb", "lib/gruff/stacked_area.rb", "lib/gruff/stacked_bar.rb", "lib/gruff/stacked_mixin.rb", "rails_generators/gruff/gruff_generator.rb", "rails_generators/gruff/templates/controller.rb", "rails_generators/gruff/templates/functional_test.rb", "test/gruff_test_case.rb", "test/test_accumulator_bar.rb", "test/test_area.rb", "test/test_bar.rb", "test/test_base.rb", "test/test_bullet.rb", "test/test_dot.rb", "test/test_legend.rb", "test/test_line.rb", "test/test_mini_bar.rb", "test/test_mini_pie.rb", "test/test_mini_side_bar.rb", "test/test_net.rb", "test/test_photo.rb", "test/test_pie.rb", "test/test_scene.rb", "test/test_side_bar.rb", "test/test_sidestacked_bar.rb", "test/test_spider.rb", "test/test_stacked_area.rb", "test/test_stacked_bar.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://nubyonrails.com/pages/gruff}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gruff}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Beautiful graphs for one or multiple datasets.}
  s.test_files = ["test/test_accumulator_bar.rb", "test/test_area.rb", "test/test_bar.rb", "test/test_base.rb", "test/test_bullet.rb", "test/test_dot.rb", "test/test_legend.rb", "test/test_line.rb", "test/test_mini_bar.rb", "test/test_mini_pie.rb", "test/test_mini_side_bar.rb", "test/test_net.rb", "test/test_photo.rb", "test/test_pie.rb", "test/test_scene.rb", "test/test_side_bar.rb", "test/test_sidestacked_bar.rb", "test/test_spider.rb", "test/test_stacked_area.rb", "test/test_stacked_bar.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end

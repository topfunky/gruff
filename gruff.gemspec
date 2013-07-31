# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'gruff/version'

Gem::Specification.new do |s|
  s.name = %q{gruff}
  s.version = Gruff::VERSION
  # s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['Geoffrey Grosenbach', 'Uwe Kubosch']
  s.date = Date.today.to_s
  s.description = %q{Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.}
  s.email = %q{boss@topfunky.com}
  # s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = `git ls-files`.split($/)
  # s.has_rdoc = true
  s.homepage = %q{http://nubyonrails.com/pages/gruff}
  # s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = %w(lib)
  # s.rubyforge_project = %q{gruff}
  # s.rubygems_version = %q{1.3.1}
  s.summary = %q{Beautiful graphs for one or multiple datasets.}
  # s.test_files = ["test/test_accumulator_bar.rb", "test/test_area.rb", "test/test_bar.rb", "test/test_base.rb", "test/test_bullet.rb", "test/test_dot.rb", "test/test_legend.rb", "test/test_line.rb", "test/test_mini_bar.rb", "test/test_mini_pie.rb", "test/test_mini_side_bar.rb", "test/test_net.rb", "test/test_photo.rb", "test/test_pie.rb", "test/test_scene.rb", "test/test_side_bar.rb", "test/test_sidestacked_bar.rb", "test/test_spider.rb", "test/test_stacked_area.rb", "test/test_stacked_bar.rb"]
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.executables = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
  # s.add_dependency(%q<rmagick>, [">= 2.12.2"])
  s.add_development_dependency('rake')
  s.license = 'MIT'
end

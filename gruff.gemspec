# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'gruff/version'

Gem::Specification.new do |s|
  s.name = %q{gruff}
  s.version = Gruff::VERSION
  s.authors = ['Geoffrey Grosenbach', 'Uwe Kubosch']
  s.date = Date.today.to_s
  s.description = %q{Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.}
  s.email = %q{boss@topfunky.com}
  # s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = `git ls-files`.split($/)
  # s.has_rdoc = true
  s.homepage = %q{https://github.com/topfunky/gruff}
  # s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = %w(lib)
  # s.rubyforge_project = %q{gruff}
  s.summary = %q{Beautiful graphs for one or multiple datasets.}
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
  if defined? JRUBY_VERSION
    s.platform = 'java'
    s.add_dependency 'rmagick4j'
  else
    s.add_dependency 'rmagick'
  end
  s.add_development_dependency('rake')
  s.license = 'MIT'
end

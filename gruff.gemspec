# -*- encoding: utf-8 -*-
# frozen_string_literal: true

lib = File.expand_path('lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'gruff/version'

Gem::Specification.new do |s|
  s.name = 'gruff'
  s.version = Gruff::VERSION
  s.authors = ['Geoffrey Grosenbach', 'Uwe Kubosch']
  s.date = Date.today.to_s
  s.description = 'Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.'
  s.email = 'boss@topfunky.com'
  s.files = `git ls-files`.split.reject do |f|
    f =~ /^test|^docker|^Rakefile/
  end
  s.homepage = 'https://github.com/topfunky/gruff'
  s.require_paths = %w[lib]
  s.summary = 'Beautiful graphs for one or multiple datasets.'
  s.license = 'MIT'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION

  if defined? JRUBY_VERSION
    s.platform = 'java'
    s.add_dependency 'rmagick4j'
  else
    s.add_dependency 'rmagick'
    s.add_development_dependency 'rubocop', '~> 1.11.0'
    s.add_development_dependency 'rubocop-performance', '~> 1.10.1'
  end
  s.add_dependency 'histogram'
  s.required_ruby_version = '>= 2.4.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'parallel'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'yard', '~> 0.9.25'
end

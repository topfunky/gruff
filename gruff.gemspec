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
  s.files = `git ls-files`.split($/).reject{|f| f =~ /^test#{File::ALT_SEPARATOR || File::SEPARATOR}output/}
  s.homepage = %q{https://github.com/topfunky/gruff}
  s.require_paths = %w(lib)
  s.summary = %q{Beautiful graphs for one or multiple datasets.}
  s.license = 'MIT'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
  s.required_ruby_version = ['>= 1.9.3', '< 3']

  if defined? JRUBY_VERSION
    s.platform = 'java'
    s.add_dependency 'rmagick4j', '~> 0.3', '>= 0.3.9'
  else
    s.add_dependency 'rmagick', '~> 2.13', '>= 2.13.4'
  end
  s.add_development_dependency('rake')
  s.add_development_dependency('minitest-reporters')
end

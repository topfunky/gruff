# frozen_string_literal: true

lib = File.expand_path('lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'gruff/version'

Gem::Specification.new do |s|
  s.name = 'gruff'
  s.version = Gruff::VERSION
  s.authors = ['Geoffrey Grosenbach', 'Uwe Kubosch']
  s.description = 'Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.'
  s.email = 'boss@topfunky.com'
  s.files = `git ls-files`.split.grep_v(/^test|^docker|^before_install_linux.sh|^Rakefile/i)
  s.homepage = 'https://github.com/topfunky/gruff'
  s.require_paths = %w[lib]
  s.summary = 'Beautiful graphs for one or multiple datasets.'
  s.license = 'MIT'
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION

  if defined? JRUBY_VERSION
    s.platform = 'java'
    s.add_dependency 'rmagick4j'
  else
    s.add_dependency 'rmagick', '>= 4.2'
    s.add_development_dependency 'rubocop', '~> 1.28.2'
    s.add_development_dependency 'rubocop-performance', '~> 1.13.3'
    s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  end
  s.add_dependency 'histogram'
  s.required_ruby_version = '>= 2.5.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard', '~> 0.9.25'

  s.metadata['rubygems_mfa_required'] = 'true'
end

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
  s.files = `git ls-files`.split.grep_v(/^test|^docker|^before_install_linux.sh|^Rakefile|^Steepfile/i)
  s.homepage = 'https://github.com/topfunky/gruff'
  s.require_paths = %w[lib]
  s.summary = 'Beautiful graphs for one or multiple datasets.'
  s.license = 'MIT'
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  if defined? JRUBY_VERSION
    s.platform = 'java'
    s.add_dependency 'rmagick4j'
  else
    s.add_dependency 'rmagick', '>= 5.5'
  end
  s.add_dependency 'bigdecimal', '>= 3.0'
  s.add_dependency 'histogram'
  s.required_ruby_version = '>= 3.0.0'

  s.metadata['bug_tracker_uri'] = 'https://github.com/topfunky/gruff/issues'
  s.metadata['changelog_uri'] = 'https://github.com/topfunky/gruff/blob/master/CHANGELOG.md'
  s.metadata['rubygems_mfa_required'] = 'true'
end

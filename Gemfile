# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in gruff.gemspec
gemspec

unless defined? JRUBY_VERSION
  gem 'rubocop', '~> 1.66'
  gem 'rubocop-minitest', '~> 0.36'
  gem 'rubocop-performance', '~> 1.21'
  gem 'rubocop-rake', '~> 0.6'
end

gem 'minitest-reporters'
gem 'rake'
gem 'simplecov'
gem 'yard', '~> 0.9.28'

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1') && !RUBY_PLATFORM.include?('java')
  gem 'rbs-inline', '~> 0.11'
  gem 'rubocop-rbs_inline', '~> 1.4'
  gem 'steep', '~> 1.10'
end

# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in gruff.gemspec
gemspec

unless defined? JRUBY_VERSION
  gem 'rubocop', '~> 1.50.2'
  gem 'rubocop-minitest', '~> 0.30.0'
  gem 'rubocop-performance', '~> 1.17.1'
  gem 'rubocop-rake', '~> 0.6.0'
end

gem 'minitest-reporters'
gem 'rake'
gem 'simplecov'
gem 'yard', '~> 0.9.28'

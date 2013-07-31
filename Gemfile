source 'https://rubygems.org'

# Specify your gem's dependencies in gruff.gemspec
gemspec

group :test do
  platform :ruby do
    gem 'rmagick'
  end

  platform :jruby do
    gem 'rmagick4j'
  end

  if RUBY_VERSION =~ /^1\.9\./ || RUBY_VERSION =~ /^2\.0\./
    gem 'minitest-reporters'
  end
end

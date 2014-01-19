source 'http://rubygems.org'

# Specify your gem's dependencies in gruff.gemspec
gemspec

group :test do
  if RUBY_VERSION =~ /^1\.9\./ || RUBY_VERSION =~ /^2\./
    gem 'minitest-reporters', '<1.0.0'
  end
end

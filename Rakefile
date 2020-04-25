require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'

CLEAN.concat %w[pkg test/output/*]

desc 'Run tests'
task default: :test

task gem: :build

Rake::TestTask.new

namespace :test do
  desc 'Run mini tests'
  task mini: :clean do
    Dir['test/test_mini*'].each do |file|
      system "ruby #{file}"
    end
  end
end

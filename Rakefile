require 'fileutils'
require 'rake/clean'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'gruff/version'

CLEAN << ['pkg', 'test/output/*']

desc "Build the gem"
task :gem do
  sh 'gem build gruff.gemspec'
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "gruff-#{Gruff::VERSION}.gem", 'pkg/'
end

namespace :test do
  desc "Run mini tests"
  task :mini => :clean do
    Dir['test/test_mini*'].each do |file|
      system "ruby #{file}"
    end
  end
end

##
# Catch unmatched tasks and run them as a unit test.
# Makes it possible to do
#
#  rake pie
#
# To run the +test/test_pie+ and +test/test_mini_pie+ files.
rule '' do |t|
  # Rake::Task["clean"].invoke
  Dir["test/test_*#{t.name}*.rb"].each do |filename|
    system "ruby #{filename}"
  end
end

require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'gruff'

Hoe.new('Gruff', Gruff::VERSION) do |p|
  p.name = "gruff"
  p.author = "Geoffrey Grosenbach"
  p.description = "Beautiful graphs for one or multiple datasets. Can be used on websites or in documents."
  p.email = 'boss@topfunky.com'
  p.summary = "Beautiful graphs for one or multiple datasets."
  p.url = "http://nubyonrails.com/pages/gruff"
  p.clean_globs = ['test/output/*.png']
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
end

desc "Simple require on packaged files to make sure they are all there"
task :verify => :package do
  # An error message will be displayed if files are missing
  if system %(ruby -e "require 'pkg/gruff-#{Gruff::VERSION}/lib/gruff'")
    puts "\nThe library files are present"
  end
end

task :release => :verify

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
#
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

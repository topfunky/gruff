require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'gruff'

Hoe.spec('Gruff') do
  self.name = "gruff"
  self.author = "Geoffrey Grosenbach"
  self.description = "Beautiful graphs for one or multiple datasets. Can be used on websites or in documents."
  self.email = 'boss@topfunky.com'
  self.summary = "Beautiful graphs for one or multiple datasets."
  self.url = "http://nubyonrails.com/pages/gruff"
  self.clean_globs = ['test/output/*.png']
  self.changes = self.paragraphs_of('History.txt', 0..1).join("\n\n")
  self.remote_rdoc_dir = '' # Release to root
end

desc "Simple require on packaged files to make sure they are all there"
task :verify => :package do
  # An error message will be displayed if files are missing
  if system %(ruby -e "require 'pkg/gruff-#{Gruff::VERSION}/lib/gruff'")
    puts "\nThe library files are present"
  end
  raise "\n*** Gruff::Base::DEBUG must be set to false for releases ***\n\n" if Gruff::Base::DEBUG
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

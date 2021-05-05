# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'

CLEAN.concat %w[pkg test/output/*]

desc 'Run tests'
task default: :test

task gem: :build

Rake::TestTask.new

namespace :test do
  desc 'Update expected image with output'
  task :"image:update" do
    require 'rmagick'
    require 'fileutils'
    require 'parallel'

    update_expected_images = lambda do |expect_dir, output_dir|
      files = Dir.glob("#{output_dir}/*.png")
      Parallel.each(files) do |output_path|
        file_name = File.basename(output_path)
        expected_path = "#{expect_dir}/#{file_name}"

        error = nil
        output_image = Magick::Image.read(output_path).first

        if File.exist?(expected_path)
          expected_image = Magick::Image.read(expected_path).first
          _, error = expected_image.compare_channel(output_image, Magick::PeakAbsoluteErrorMetric)
        end

        if error != 0.0
          FileUtils.copy(output_path, expected_path)
        end
      end
    end

    update_expected_images.call('test/expected', 'test/output')
  end
end

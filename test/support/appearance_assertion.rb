require 'minitest/unit'

module MiniTest
  module Assertions
    def assert_same_image(expected_image_path, output_image, delta = 0.0)
      # not supported yet
      return if RUBY_PLATFORM == 'java'

      expected_path = File.expand_path(expected_image_path)
      expected_image = Magick::Image.read(expected_path).first

      if output_image.is_a?(String)
        output_path = File.expand_path(output_image)
        output_image = Magick::Image.read(output_path).first
      end

      _, error = expected_image.compare_channel(output_image, Magick::PeakAbsoluteErrorMetric)
      assert_in_delta(0.0, error, delta)
    end
  end
end

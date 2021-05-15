# frozen_string_literal: true

# Handle font setting to draw texts
class Gruff::Font
  BOLD_PATH = File.expand_path(File.join(__FILE__, '../../../assets/fonts/Roboto-Bold.ttf')).freeze
  REGULAR_PATH = File.expand_path(File.join(__FILE__, '../../../assets/fonts/Roboto-Regular.ttf')).freeze

  # Get/set font path.
  attr_accessor :path

  # Get/set font size.
  attr_accessor :size

  # Get/set font setting whether render bold text.
  attr_accessor :bold

  # Get/set font color.
  attr_accessor :color

  def initialize(path: nil, size: 20.0, bold: false, color: 'white')
    @path = path
    @bold = bold
    @size = size
    @color = color
  end

  # Get font weight.
  # @return [Magick::WeightType] font weight
  def weight
    @bold ? Magick::BoldWeight : Magick::NormalWeight
  end

  # @private
  def file_path
    return @path if @path

    @bold ? BOLD_PATH : REGULAR_PATH
  end
end

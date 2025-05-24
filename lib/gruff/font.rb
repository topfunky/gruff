# frozen_string_literal: true

# rbs_inline: enabled

# Handle font setting to draw texts
class Gruff::Font
  BOLD_PATH = File.expand_path(File.join(__FILE__, '../../../assets/fonts/Roboto-Bold.ttf')).freeze
  private_constant :BOLD_PATH

  REGULAR_PATH = File.expand_path(File.join(__FILE__, '../../../assets/fonts/Roboto-Regular.ttf')).freeze
  private_constant :REGULAR_PATH

  # Get/set font path.
  attr_accessor :path #: String

  # Get/set font size.
  attr_accessor :size #: Float | Integer

  # Get/set font setting whether render bold text.
  attr_accessor :bold #: bool

  # Get/set font color.
  attr_accessor :color #: String

  # @rbs path: String | nil
  # @rbs size: Float | Integer
  # @rbs bold: bool
  # @rbs color: String
  def initialize(path: nil, size: 20.0, bold: false, color: 'white')
    @path = path
    @bold = bold
    @size = size
    @color = color
  end

  # Get font weight.
  # @return [Magick::WeightType] font weight
  # TODO: type annotation of return value
  def weight
    @bold ? Magick::BoldWeight : Magick::NormalWeight
  end

  # @private
  # @rbs return: String
  def file_path
    return @path if @path

    @bold ? BOLD_PATH : REGULAR_PATH
  end
end

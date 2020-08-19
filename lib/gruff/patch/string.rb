# frozen_string_literal: true

class String
  def commify(delimiter, separator: nil)
    gsub('.', separator).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end
end

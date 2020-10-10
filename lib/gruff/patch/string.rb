# frozen_string_literal: true

# @private
class String
  THOUSAND_SEPARATOR = ','

  #Taken from http://codesnippets.joyent.com/posts/show/330
  def commify(delimiter = THOUSAND_SEPARATOR)
    gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end
end

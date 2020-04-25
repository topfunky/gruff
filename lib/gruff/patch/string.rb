# frozen_string_literal: true

class String
  #Taken from http://codesnippets.joyent.com/posts/show/330
  def commify(delimiter = ',')
    gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end
end

# frozen_string_literal: true
# rbs_inline: enabled

# @private
module String::GruffCommify
  THOUSAND_SEPARATOR = ','
  private_constant :THOUSAND_SEPARATOR

  refine String do
    # Taken from http://codesnippets.joyent.com/posts/show/330
    def commify(delimiter = THOUSAND_SEPARATOR)
      gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}") # steep:ignore
    end
  end
end

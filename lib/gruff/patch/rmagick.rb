# frozen_string_literal: true

module Magick
  class Draw
    # Additional method to scale annotation text since Draw.scale doesn't.
    def annotate_scaled(img, width, height, x, y, text, scale)
      scaled_width = (width * scale) >= 1 ? (width * scale) : 1
      scaled_height = (height * scale) >= 1 ? (height * scale) : 1

      annotate(img,
               scaled_width, scaled_height,
               x * scale, y * scale,
               text.gsub('%', '%%'))
    end

    if defined? JRUBY_VERSION
      # FIXME(uwe):  We should NOT need to implement this method.
      #              Remove this method as soon as RMagick4J Issue #16 is fixed.
      #              https://github.com/Serabe/RMagick4J/issues/16
      def fill=(fill)
        fill = { white: '#FFFFFF' }[fill.to_sym] || fill
        @draw.fill = Magick4J.ColorDatabase.query_default(fill)
        self
      end
      # EMXIF
    end
  end
end

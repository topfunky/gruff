module Gruff
  module Themes
    
    # A color scheme similar to the popular presentation software.
    KEYNOTE = {
      :colors => [
        '#FDD84E',  # yellow
        '#6886B4',  # blue
        '#72AE6E',  # green
        '#D1695E',  # red
        '#8A6EAF',  # purple
        '#EFAA43',  # orange
        'white'
      ],
      :marker_color => 'white',
      :font_color => 'white',
      :background_colors => %w(black #4a465a)
    }

    # A color scheme plucked from the colors on the popular usability blog.
    THIRTYSEVEN_SIGNALS = {
      :colors => [
        '#FFF804',  # yellow
        '#336699',  # blue
        '#339933',  # green
        '#ff0000',  # red
        '#cc99cc',  # purple
        '#cf5910',  # orange
        'black'
      ],
      :marker_color => 'black',
      :font_color => 'black',
      :background_colors => %w(#d1edf5 white)
    }

    # A color scheme from the colors used on the 2005 Rails keynote
    # presentation at RubyConf.
    RAILS_KEYNOTE = {
      :colors => [
        '#00ff00',  # green
        '#333333',  # grey
        '#ff5d00',  # orange
        '#f61100',  # red
        'white',
        '#999999',  # light grey
        'black'
      ],
      :marker_color => 'white',
      :font_color => 'white',
      :background_colors => %w(#0083a3 #0083a3)
    }

    # A color scheme similar to that used on the popular podcast site.
    ODEO = {
      :colors => [
        '#202020',  # grey
        'white',
        '#3a5b87',  # dark blue
        '#a21764',  # dark pink
        '#8ab438',  # green
        '#999999',  # light grey
        'black'
      ],
      :marker_color => 'white',
      :font_color => 'white',
      :background_colors => %w(#ff47a4 #ff1f81)
    }

    # A pastel theme
    PASTEL = {
      :colors => [
        '#a9dada', # blue
        '#aedaa9', # green
        '#daaea9', # peach
        '#dadaa9', # yellow
        '#a9a9da', # dk purple
        '#daaeda', # purple
        '#dadada' # grey
      ],
      :marker_color => '#aea9a9', # Grey
      :font_color => 'black',
      :background_colors => 'white'
    }

    # A greyscale theme
    GREYSCALE = {
      :colors => [
        '#282828', #
        '#383838', #
        '#686868', #
        '#989898', #
        '#c8c8c8', #
        '#e8e8e8', #
      ],
      :marker_color => '#aea9a9', # Grey
      :font_color => 'black',
      :background_colors => 'white'
    }
    
  end
end


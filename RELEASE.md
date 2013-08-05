Subject: [ANN] Gruff 0.4.0 released!

The Gruff team is pleased to announce the release of Gruff 0.4.0.

New in version 0.4.0:

All old branches and pull requests have been merged or deleted.  Over 40
issues have been resolved!  Ruby 2.0 compatibility has been confirmed.
Several new features.

Features:

* Issue #38 Separate themes into Gruff::Themes module
* Issue #39 Add staggered labels
* Issue #40 Added spacing factor to bar graphs
* Issue #41 Add rotation to spider chart
* Issue #65 Add RMagick and RMagick4J respectively as dependencies to the
  Gruff gem
* Issue #81 Ensure Ruby 2.0 compatibility
    
Bugfixes:

* Issue #17 Baseline drawn at incorrect position
* Issue #21 Division By Zero Error on Documented Example
* Issue #36 When writing the same chart multiple times, it should not be
  rendered again.
* Issue #44 XY Datasets are inconvenient to use. (documentation and/or
  code is wrong)
* Issue #46 issue with markers that are floats
* Issue #51 line with nil in dataset
* Issue #52 Wrong direction in y_axis_label
* Issue #54 Explicitly specify overlapping for lines (Gruff::Line)
* Issue #58 Clean up data sorting
* Issue #59 Escape '%' in labels
* Issue #60 Correct DOT graph drawing
* Issue #63 Some charts are drawn with transparent text when running with
  JRuby/RMagick4J
* Issue #66 Marker line for 54.0 is missing on bar_set_marker.png example
* Issue #68 Y-axis label for bar_x_y_labels.png should be rotated when
  drawn with JRuby
    
Support:

* Issue #4 Scaling a graph leads to fuzzy pictures
* Issue #8 zero-width bar entries drawn
* Issue #11 Feature: Data value markers
* Issue #18 Set encoding to uft-8
* Issue #24 Gruff::SideStackedBar
* Issue #35 Add option for line height in legend.
* Issue #49 font directive is not setting font in charts
* Issue #53 Is this project still alive?
    
Documentation:

* Issue #57 Build failing on Travis and no Build Status image in Readme
    
Pull requests:

* Issue #9 Add gradient background direction
* Issue #12 Bar updates
* Issue #14 Make use of the TEXT_OFFSET_PERCENTAGE const variable
* Issue #16 Fix exception when y_axis_increment is used in line bars
* Issue #26 Fix bug with additional point included on area charts
* Issue #27 Added marker_shadow_color to allow to draw shadows below
  marker lines
* Issue #37 Update lib/gruff/base.rb: set legend under the graph
* Issue #42 Update lib/gruff/base.rb: set legend under the graph
* Issue #43 Fixed issue #25
* Issue #48 add license information to the gemspec
* Issue #56 Fixed gem file generation problem
    
Internal:

* Issue #80 Remove the .rmvrc file from the project
    
You can find a complete list of issues here:

* https://github.com/topfunky/gruff/issues?state=closed&milestone=2


Installation:

    gem install gruff

You can find an introductory tutorial at
https://github.com/topfunky/gruff

Enjoy!


--
The Gruff Team

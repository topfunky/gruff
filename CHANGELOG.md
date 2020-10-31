# Change Log

## 0.12.0
- Mark Gruff::Base#to_blob as deprecated (#473)
- Add Gruff::Base#to_image method (#472)
- Drop support of Ruby v2.3.x or below (#453, #448)
- add hide_labels to stacked side bar graphs (#452)
- add hide_labels to side bar graphs (#451)
- add hide_labels to stacked bar graphs (#450)
- support hide_labels separate from hide_line_markers for bar graphs only (#446)

## 0.11.0
- Fix regression in empty data handling (#445)
- Rendering text in front most (#439)
- Allow to change settings even after entered the data in Gruff::Histogram (#437)
- Adjust label position in Gruff::Net (#436)
- Adjust LABEL_MARGIN value (#435)
- Add shadow line in marker line into Gruff::{Dot, SideBar, Scatter} (#430)
- Move no data message to the vertical center (#428)
- Remove the getter method in attributes for configuration (#424)
- Fix title margin in Gruff::Bullet if empty title was given (#422)

## 0.10.0

* Add Histogram chart (#419)
* Fix that Y axis label is not displayed on JRuby platform (#415)
* Add fill_opacity and stroke_width in Gruff::Area in order to specify the filling opacity (#413)
* Fix "`get_type_metrics': no text to measure" exception (#410, #409)

## 0.9.0

* Fix that sidebar label is not displayed on JRuby platform (#402)
* Add `group_spacing` which is spacing factor applied between a group of bars belonging to the same label (#400)
* Fix that label is displayed in the center of the side bar (#399)
* Fix that value label is displayed in the center of the side bar (#398)
* Add `show_labels_for_bar_values` into StackedBar (#396)
* Auto resize title font size if long title will be cut off (#395)
* Adjust label position in StackedBar (#394)
* Fix that labels are rendered in the center of bar graph (#393)
* Remove `stacked` property marked as experimental (#392)
* Fix to not move away from the baseline if big value was given into `segment_spacing` (#391)
* Add `segment_spacing property` into SideStackedBar like StackedBar (#390)
* Fix an exception when using an object as an argument that behaves as an Array (#317)
* Add `Scatter#dataxy` method like `Line#dataxy` (#316)
* Retry to fill background to fix "cache resources exhausted" error (#305)
* Fix label position in Gruff::Bar with negative value (#265)
* Fixed a bug that did not handle the specified minimum/maximum properly (#260)
* Fix error of “comparison of Integer with nil failed” (#257, #366, #367)
* Fix redundant label padding with many decimal points (#254)
* Fix that value label might be displayed with scientific notation (#252)

## 0.8.0

* Remove version restriction in RMagick (#186)
* Remove the upper limit (< Ruby 3.0) from the required Ruby version (#207)

## 0.5.1

Skip packaging the test images.  This reduces the gem from 20MB+ to
300KB+.

Bugfixes:

* Issue #92 Reduce the gem size by not shipping the test images.


## 0.5.0

We have added a couple of cosmetic changes:  Multiple marker lines both
vertically and horizontally, and multi-line titles, or no title at all if
you want more space for the chart.

Features:

* Issue #86 Added support for multiple references lines along both axes to
  Line Graph
* Issue #89 Allow multiline and empty titles

Documentation:

* Issue #61 Remove the "BETA Software" warning in the README.

Pull requests:

* Issue #90 Added missing parenthesis in base.rb


## 0.4.0

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


## 0.3.7

* ???

## 0.3.6

* Fixed manifest to list dot graph [theirishpenguin]
* Fixed color cycling error [Gunnar Wolf]
* Handle case where a line graph data set only has one value [Ron Colwill]

## 0.3.5

* Added dot graph from Erik Andrejko

## 0.3.4

* Reverted DEBUG=true. Will add a check in the release process so this doesn't happen again.
* Future releases will end in an odd number for development (topfunky-gruff on GitHub) or even for production releases.

## 0.3.3

* Legend line wrapping [Mat Schaffer]
* Stacked area graph fixes [James Coglan]

## 0.3.2

* Include init.rb for use as a Rails plugin.

## 0.3.1

* Fixed missing bullet graph bug (experimental, will be in a future release).

## 0.3.0

* Fixed bug where pie graphs weren't drawing their label correctly.

## 0.2.9

* Patch to make SideBar accurate instead of stacked [Marik]
* Will be extracting net, pie, stacked, and side-stacked to separate gem
  in next release.

## 0.2.8

* New accumulator bar graph (experimental)
* Better mini graphs
* Bug fixes

## 0.2.7

* Regenerated Manifest.txt
* Added scene sample to package
* Added mini side_bar (EXPERIMENTAL)
* Added @zero_degree option to Gruff::Pie so first slice can start somewhere other than 3 o'clock
* Increased size of numbers in Gruff::Mini::Pie
* Added legend_box_size accessor

## 0.2.6

* Fixed missing side_bar.rb in Manifest.txt

## 0.2.5

* New mini graph types (Experimental)
* Marker lines can be different color than text labels
* Theme definition cleanup

## 0.2.4

* Added option to hide line numbers
* Fixed code that was causing warnings

## 0.2.3

* Cleaned up measurements so the graph expands to fill the available space
* Added x-axis and y-axis label options

## 0.1.2

* minimum_value and maximum_value can be set after data() to manually scale the graph
* Fixed infinite loop bug when values are all equal
* Added experimental net and spider graphs
* Added non-linear scene graph for a simple interface to complex layered graphs
* Initial refactoring of tests
* A host of other bug fixes

## 0.0.8

* NEW Sidestacked Bar Graphs. [Alun Eyre]
* baseline_value larger than data will now show correctly. [Mike Perham]
* hide_dots and hide_lines are now options for line graphs.

## 0.0.6

* Fixed hang when no data is passed.

## 0.0.4

* Added bar graphs
* Added area graphs
* Added pie graphs
* Added render_image_background for using images as background on a theme
* Fixed small size legend centering issue
* Added initial line marker rounding to significant digits (Christian Winkler)
* Line graphs line width is scaled with number of points being drawn (Christian Winkler)

## 0.0.3

* Added option to draw line graphs without the lines (points only), thanks to Eric Hodel
* Removed font-minimum check so graphs look better at 300px width

## 0.0.2

* Fixed to_blob (thanks to Carlos Villela)
* Added bar graphs (initial functionality...will be enhanced)
* Removed rendered test output from gem

## 0.0.1

* Initial release.
* Line graphs only. Other graph styles coming soon.

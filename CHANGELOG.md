# Change Log

## 0.29.0

- Line graph: reset previous point between dataxy series to prevent unwanted poly‑line connection (#665)

## 0.28.0

- Fix Gruff::Line to prevent unknown lines drawing (#664)

## 0.27.1

- RBS: Fix wrong type declarations (#662)

## 0.27.0

- Add RBS signatures (#661)
- Fix Gruff::Bezier raises exception if data contains nil (#660)
- Fix Gruff::Pie raises exception if data contains nil (#659)
- Fix Gruff::Net raises exception if data contains nil (#658)
- Fix Gruff::Histogram raises exception if data contains nil (#657)
- Fix Gruff::Dot raises exception if data contains nil (#656)
- Fix Gruff::Candlestick raises exception if data contains nil (#655)
- Fix Gruff::AccumulatorBar raises exception if data contains nil (#654)
- Fix Gruff::Area raises exception if data contains nil (#653)
- Fix Gruff::StackedArea raises exception if data contains nil (#652)
- Stop using Struct to make it easier to write type definitions (#651)
- Fix Gruff::Box raises exception if data contains nil (#648)
- Fix Gruff::SideStackedBar raises exception if data contains nil (#647)
- Fix Gruff::StackedBar raises exception if data contains nil (#646)

## 0.26.0

- Allow customizing No Data font size (#642)

## 0.25.0
- Add bigdecimal gem as dependency for Ruby 3.4
- Update dependent RMagick version to 5.5.0 or later
- Drop Ruby 2.6 and 2.7 support (#632)

## 0.24.0
- Add the way to make background transparent (#631)
- Adjust line number position on side graph (#624)
- Add hide_labels attribute in Gruff::Dot (#623)
- Fix where SideBar's labels were sometimes missing by incorrect left margin

## 0.23.0
- Update dependent RMagick version to 5.3.0 or later (#622)

## 0.22.0
- Fix Gruff::Bar and Gruff::SideBar in order to draw positive and negative mixed graph (#620)
- Allow to override label margin value (#618)
- Accept image format in Base#to_image in order to fix `no decode delegate for this image format` error (#619)

## 0.21.0
- Fix legend color with empty label (#615)

## 0.20.0
- Fix legend position when blank labels present (#614)
- Fixed NoMethodError (undefined method `format=` for Gruff::Line (#612)
- Drop Ruby 2.5 support (#611)
- Fix deprecation warning for Base#to_blob (#610)

## 0.19.0
- Draw the graph starting from zero point by default (#609)
- Improve joints in Gruff::Net using polyline method (#608)
- Improve joints in Gruff::Line using polyline method (#607)
- Adjust default font size in Gruff::Mini::{Bar, Pie}

## 0.18.0
- Add Gruff::Bubble (#604)
- Rename Gruff::BoxPlot to Gruff::Box (#603)
- Mark Gruff::Scatter#disable_significant_rounding_x_axis= as deprecated (#602)
- Mark Gruff::Scatter#x_label_margin= as deprecated (#601)
- Mark Gruff::Scatter#use_vertical_x_labels= as deprecated (#600)

## 0.17.0
- Add Gruff::Base#label_rotation= method to rotate bottom label (#599)
- Mark #label_stagger_height= as deprecated (#598)
- Fixed truncation of long legends in mini graph (#597)
- Fix error when input empty data in Gruff::Bezier (#596)
- Fix error when input empty data in Gruff::StackedArea (#595)
- Fix error when input empty data in Gruff::BoxPlot (#594)
- Fix error when input empty data in Gruff::Spider (#593)
- Fix error when input empty data in Gruff::Histogram (#592)
- Fix error when input empty data in Gruff::Area (#591)
- Stop adjusting the square radius in Gruff::Line (#589)
- Add diamond dot style in Gruff::Line (#588)
- Allow title to be set as an array (#587)
- Allow labels to be set as an array corresponding to the data values (#586)
- Fixed a bug that breaks the colors in the theme when using the add_color method (#583)
- Ensure to raise an exception if use sort feature in Candlestick
- Fix column_count in BoxPlot/Candlestick (#581)
- Fix left/right graph margin (#579)

## 0.16.0
- Add Candlestick (#575)
- Add BoxPlot (#574)
- Raise exception if less data set was given in Gruff::Spider (#573)
- Adjust default label offset value in Gruff::Pie
- Remove has_left_labels from attribute (#571)
- Remove center_labels_over_point from attribute (#570)
- Adjust legend label / box position
- Fix right margin when truncate the label
- Adjust axis label position
- Adjust left label margin
- Fix axis label position with hide_line_markers
- Fix margin of value label in Bar/StackedBar (#568)
- Fix label position in Gruff::Spider (#567)
- Fix axis label position with legend_at_bottom
- Fix axis label position with hide_line_markers
- Refactor: Remove instance variable usage
- Remove Gruff::Scene (#566)
- Fix exception with zero value in StackBar (#565)
- Fix segment spacing in SideStackedBar (#564)
- Fix margin of value label in SideBar/SideStackedBar (#563)
- Raise exception if negative values were given in stacked graph (#562)
- Fix centering in value label position (#561)
- Fix duck typing support in Gruff::Histogram (#560)
- Fix start drawing position to top in Pie and enabled sort option by default (#559)

## 0.15.0
- Fix SideStackedBar which bars overlap on the coordinate axes if data contains 0 (#558)
- Lazy loading library to reduce memory usage (#556)
- Drop Ruby 2.4 support (#554)
- Fix sort drawing in Gruff::Line (#553)
- Fix color value handling in Line#dataxy method (#552)

## 0.14.0
- Update rails template (#547)
- Remove singleton in order to support multi-thread processing (#546)
- Fix bug in Gruff::Scatter that X coordinate value is wrong if set value in x_axis_increment (#534)
- Add marker_x_count attribute in Gruff::Line (#532)
- Add label_formatting attribute in Gruff::Pie (#531)
- Removed the ability to inject custom PieSlice classes from the outside (#530)
- Remove Gruff::PhotoBar (#513)
- Deprecate last_series_goes_on_bottom attribute in Gruff::StackedArea (#512)

## 0.13.0
- Allow to customize label value with lambda (#510)
- Rename enable_vertical_line_markers attribute to show_vertical_markers (#509)
- Fix error that cause ArgumentError with x_axis_increment in Gruff::Scatter (#506)
- Fix draw_label that it should follow label_truncation_style setting (#505)
- Deprecate use_data_label attribute from SideBar (#504)
- Add negative values graph support in Gruff::SideBar (#499)
- Add margin of axis in order to avoid overwriting the coordinate axes (#497)
- Fix get_type_metrics error (#496)
- Embed Roboto as default font (#495)
- Fix legend rendering position when it enable legend_at_bottom (#492)

## 0.12.2
- Avoid SEGV caused with '%S' in Draw#get_type_metrics by old ImageMagick (6.9.9 or below)  (#490)

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

# Gruff Graphs

[![Build Status](https://travis-ci.org/topfunky/gruff.svg?branch=master)](https://travis-ci.org/topfunky/gruff)
[![Gem Version](https://badge.fury.io/rb/gruff.svg)](https://badge.fury.io/rb/gruff)

A library for making beautiful graphs.

## Installation

Add this line to your application's Gemfile:

    gem 'gruff'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gruff

## Usage

```Ruby
require 'gruff'
g = Gruff::Line.new
g.title = 'Wow!  Look at this!'
g.labels = { 0 => '5/6', 1 => '5/15', 2 => '5/24', 3 => '5/30', 4 => '6/4',
             5 => '6/12', 6 => '6/21', 7 => '6/28' }
g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
g.write('exciting.png')
```

## Examples

You can find many examples in the [test](https://github.com/topfunky/gruff/tree/master/test)
directory along with their resulting charts in the
[output](https://github.com/topfunky/gruff/tree/master/test/output) directory.

You can find older examples here:  http://nubyonrails.com/pages/gruff

### Accumulator bar chart

![Accumulator bar chart](https://raw.github.com/topfunky/gruff/master/test/output/accum_bar.png)

### Area chart

![Area chart](https://raw.github.com/topfunky/gruff/master/test/output/area_keynote.png)

### Bar chart

![Bar chart](https://raw.github.com/topfunky/gruff/master/test/output/bar_rails_keynote.png)

### Bezier chart

In progress!

![Bezier chart](https://raw.github.com/topfunky/gruff/master/test/output/bezier_3.png)

### Bullet chart

In progress!

![Bullet chart](https://raw.github.com/topfunky/gruff/master/test/output/bullet_greyscale.png)

### Dot chart

![Dot chart](https://raw.github.com/topfunky/gruff/master/test/output/dot.png)

### Line chart

![Line chart](https://raw.github.com/topfunky/gruff/master/test/output/line_theme_rails_keynote_.png)

### LineXY chart

![LineXY chart](https://raw.github.com/topfunky/gruff/master/test/output/line_xy.png)

### Net chart

![Net chart](https://raw.github.com/topfunky/gruff/master/test/output/net_wide_graph.png)

### Pie chart

![Pie chart](https://raw.github.com/topfunky/gruff/master/test/output/pie_pastel.png)

### Scatter chart

![Scatter chart](https://raw.github.com/topfunky/gruff/master/test/output/scatter_basic.png)

### Side bar chart

![Side bar chart](https://raw.github.com/topfunky/gruff/master/test/output/side_bar.png)

### Side stacked bar chart

![Side stacked bar chart](https://raw.github.com/topfunky/gruff/master/test/output/side_stacked_bar_keynote.png)

### Spider chart

![Spider chart](https://raw.github.com/topfunky/gruff/master/test/output/spider_37signals.png)

### Stacked area chart

![Stacked area chart](https://raw.github.com/topfunky/gruff/master/test/output/stacked_area_keynote.png)

### Stacked bar chart

![Stacked bar chart](https://raw.github.com/topfunky/gruff/master/test/output/stacked_bar_keynote.png)


## Documentation

http://www.rubydoc.info/github/topfunky/gruff/frames

## Supported Ruby Versions

We aim to support all Ruby implementations supporting Ruby language level 1.9.3
or later.  Currently we are running CI for MRI, JRuby, and Rubinius.

## Contributing

### Source

The source for this project is now kept at GitHub:

http://github.com/topfunky/gruff

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Gruff Graphs

[![CI](https://github.com/topfunky/gruff/actions/workflows/ci.yml/badge.svg)](https://github.com/topfunky/gruff/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/gruff.svg)](https://badge.fury.io/rb/gruff)

A library for making beautiful graphs.

Built on top of [rmagick](https://github.com/rmagick/rmagick); see its web page
for a list of the system-level prerequisites (ImageMagick etc) and how to install them.

## Installation

Add this line to your application's Gemfile:

```sh
gem 'gruff'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install gruff
```

## Font
Gruff uses [Roboto](https://fonts.google.com/specimen/Roboto) font as default font which is licensed under the Apache License, Version 2.0.

## Usage

```ruby
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
[expected](https://github.com/topfunky/gruff/tree/master/test/expected) directory.

### Accumulator bar chart

![Accumulator bar chart](https://raw.github.com/topfunky/gruff/master/test/expected/accum_bar.png)

### Area chart

![Area chart](https://raw.github.com/topfunky/gruff/master/test/expected/area_keynote.png)

### Bar chart

![Bar chart](https://raw.github.com/topfunky/gruff/master/test/expected/bar_rails_keynote.png)

### Bezier chart

In progress!

![Bezier chart](https://raw.github.com/topfunky/gruff/master/test/expected/bezier_3.png)

### Bullet chart

In progress!

![Bullet chart](https://raw.github.com/topfunky/gruff/master/test/expected/bullet_greyscale.png)

### Dot chart

![Dot chart](https://raw.github.com/topfunky/gruff/master/test/expected/dot.png)

### Line chart

![Line chart](https://raw.github.com/topfunky/gruff/master/test/expected/line_theme_rails_keynote_.png)

### LineXY chart

![LineXY chart](https://raw.github.com/topfunky/gruff/master/test/expected/line_xy.png)

### Net chart

![Net chart](https://raw.github.com/topfunky/gruff/master/test/expected/net_wide_graph.png)

### Pie chart

![Pie chart](https://raw.github.com/topfunky/gruff/master/test/expected/pie_pastel.png)

### Scatter chart

![Scatter chart](https://raw.github.com/topfunky/gruff/master/test/expected/scatter_basic.png)

### Side bar chart

![Side bar chart](https://raw.github.com/topfunky/gruff/master/test/expected/side_bar.png)

### Side stacked bar chart

![Side stacked bar chart](https://raw.github.com/topfunky/gruff/master/test/expected/side_stacked_bar_keynote.png)

### Spider chart

![Spider chart](https://raw.github.com/topfunky/gruff/master/test/expected/spider_37signals.png)

### Stacked area chart

![Stacked area chart](https://raw.github.com/topfunky/gruff/master/test/expected/stacked_area_keynote.png)

### Stacked bar chart

![Stacked bar chart](https://raw.github.com/topfunky/gruff/master/test/expected/stacked_bar_keynote.png)

### Histogram chart

![Histogram chart](https://raw.github.com/topfunky/gruff/master/test/expected/histogram.png)

### Box chart

![Box chart](https://raw.github.com/topfunky/gruff/master/test/expected/box.png)

### Candlestick

![Candlestick](https://raw.github.com/topfunky/gruff/master/test/expected/candlestick.png)

### Bubble chart

![Bubble chart](https://raw.github.com/topfunky/gruff/master/test/expected/bubble.png)

## Documentation

http://www.rubydoc.info/github/topfunky/gruff/frames

## Supported Ruby Versions

- Ruby 3.0 or later
- JRuby 9.4.x or later

## Development
1. Build docker image
```sh
$ ./docker-build.sh
```

2. Launch docker image
```sh
$ ./docker-launch.sh
```

3. Run tests
```sh
$ bundle exec rake
```

If you have made changes that involve updating the expected image, you need to update the image with the following command after running tests.

```sh
$ bundle exec rake test:image:update
```

If you change the method, you need to update RBS signatures.

```
$ rake rbs:update
```

## Contributing

### Source

The source for this project is now kept at GitHub:

http://github.com/topfunky/gruff

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

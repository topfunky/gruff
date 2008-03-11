#!/bin/sh

# Install libraries for rmagick, using darwinports.
#
# Geoffrey Grosenbach boss@topfunky.com
#

sudo port install jpeg
sudo port install libpng
sudo port install libwmf
sudo port install tiff
sudo port install lcms
sudo port install freetype
sudo port install imagemagick
sudo gem install rmagick

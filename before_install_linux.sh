#!/usr/bin/env bash

set -euox pipefail

if [ -v STYLE_CHECKS ]; then
  set +ux
  exit 0
fi

if [ ! -v IMAGEMAGICK_VERSION ]; then
  echo "you must specify an ImageMagick version."
  echo "example: 'IMAGEMAGICK_VERSION=6.8.9-10 bash ./before_install_linux.sh'"
  exit 1
fi

# remove all existing imagemagick related packages
sudo apt-get autoremove -y imagemagick* libmagick* --purge

# install build tools, ImageMagick delegates
sudo apt-get install -y build-essential libx11-dev libxext-dev zlib1g-dev \
  liblcms2-dev libpng-dev libjpeg-dev libfreetype6-dev \
  libtiff5-dev libwebp-dev liblqr-1-0-dev vim gsfonts ghostscript

project_dir=$(pwd)
build_dir="${project_dir}/build-ImageMagick/ImageMagick-${IMAGEMAGICK_VERSION}"
if [ -v CONFIGURE_OPTIONS ]; then
  build_dir="${build_dir}-${CONFIGURE_OPTIONS}"
fi

build_imagemagick() {
  mkdir -p build-ImageMagick

  version=(${IMAGEMAGICK_VERSION//./ })
  wget "https://imagemagick.org/archive/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz"
  tar -xf "ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz"
  rm "ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz"
  mv "ImageMagick-${IMAGEMAGICK_VERSION}" "${build_dir}"

  options="--with-magick-plus-plus=no --disable-docs"
  if [ -v CONFIGURE_OPTIONS ]; then
    options="${CONFIGURE_OPTIONS} ${options}"
  fi

  cd "${build_dir}"
  ./configure --prefix=/usr "${options}"
  make -j
}

if [ ! -d "${build_dir}" ]; then
  build_imagemagick
fi

cd "${build_dir}"
sudo make install -j
cd "${project_dir}"

sudo ldconfig

set +ux

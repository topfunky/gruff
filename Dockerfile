FROM ubuntu:24.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
RUN apt update -y && \
    apt install -y tzdata sudo && \
    apt install -y make build-essential git bzip2 wget zlib1g-dev libyaml-dev libgdbm-dev libreadline-dev libffi-dev

ENV RUBY_CONFIGURE_OPTS="--disable-install-doc"
RUN git clone --depth 1 https://github.com/rbenv/ruby-build.git && \
    cd ruby-build/bin && ./ruby-build 4.0.4 /usr/local

RUN mkdir /tmp/gruff
WORKDIR /tmp/gruff
ADD Gemfile /tmp/gruff/Gemfile
ADD gruff.gemspec /tmp/gruff/gruff.gemspec
ADD lib /tmp/gruff/lib/
ADD before_install_linux.sh /tmp/gruff/before_install_linux.sh

ENV IMAGEMAGICK_VERSION=7.1.2-22
RUN bash /tmp/gruff/before_install_linux.sh && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler && \
    bundle install

WORKDIR /opt/gruff

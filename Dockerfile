FROM ubuntu:24.04

RUN apt update && \
    apt install -y tzdata sudo && \
    apt install -y make build-essential git bzip2 wget zlib1g-dev libgdbm-dev libreadline-dev libffi-dev

RUN git clone --depth 1 https://github.com/rbenv/ruby-build.git && \
    cd ruby-build/bin && ./ruby-build 3.0.6 /usr/local

RUN mkdir /tmp/gruff
WORKDIR /tmp/gruff
ADD Gemfile /tmp/gruff/Gemfile
ADD gruff.gemspec /tmp/gruff/gruff.gemspec
ADD lib /tmp/gruff/lib/
ADD before_install_linux.sh /tmp/gruff/before_install_linux.sh

ENV IMAGEMAGICK_VERSION 7.1.1-33
RUN bash /tmp/gruff/before_install_linux.sh && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler:2.5.7 && \
    bundle install

WORKDIR /opt/gruff

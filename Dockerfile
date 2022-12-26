FROM ubuntu:22.04

RUN apt update && \
    apt install -y tzdata sudo && \
    apt install -y make gcc git bzip2 wget zlib1g-dev libgdbm-dev libreadline-dev libffi-dev

RUN git clone --depth 1 https://github.com/rbenv/ruby-build.git && \
    cd ruby-build/bin && ./ruby-build 2.6.10 /usr/local

RUN mkdir /tmp/gruff
WORKDIR /tmp/gruff
ADD Gemfile /tmp/gruff/Gemfile
ADD gruff.gemspec /tmp/gruff/gruff.gemspec
ADD lib /tmp/gruff/lib/
ADD before_install_linux.sh /tmp/gruff/before_install_linux.sh

ENV IMAGEMAGICK_VERSION 7.1.0-55
RUN bash /tmp/gruff/before_install_linux.sh && \
    rm -rf /var/lib/apt/lists/* && \
    bundle install

WORKDIR /opt/gruff

FROM ubuntu:18.04

RUN apt update && \
    apt install -y gcc git pkg-config ruby ruby-dev libmagickwand-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler

RUN mkdir /tmp/gruff
WORKDIR /tmp/gruff
ADD Gemfile /tmp/gruff/Gemfile
ADD gruff.gemspec /tmp/gruff/gruff.gemspec
ADD lib /tmp/gruff/lib/
RUN bundle install

WORKDIR /opt/gruff

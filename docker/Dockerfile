FROM ubuntu:18.04

RUN apt update && apt install -y gcc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev \
    libmagickwand-dev wget git pkg-config && \
    wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.1.tar.gz && \
    tar xvzf ruby-2.7.1.tar.gz && \
    cd ruby-2.7.1 && \
    ./configure --prefix=/usr --disable-install-rdoc && \
    make -j install && \
    cd .. && rm -rf ruby-2.7.1 && \
    gem install bundler -v 1.17.3 && \
    /usr/bin/bundle config set --local path 'vendor/bundle'

WORKDIR /opt/gruff

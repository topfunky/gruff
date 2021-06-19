#!/bin/bash

prject_dir="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/"
docker run -v $prject_dir:/opt/gruff --rm -it gruff bash

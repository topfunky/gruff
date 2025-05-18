#!/bin/bash

project_dir="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/"
docker run -v $project_dir:/opt/gruff --rm -it gruff bash

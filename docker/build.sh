#!/bin/bash

script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
docker build --platform linux/amd64 -t gruff ${script_dir}

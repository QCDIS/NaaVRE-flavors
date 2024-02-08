#!/bin/sh
set -e
dir="${0%/*}"
find "$dir" -name "*.R" -print0 | xargs --null -I "{}" Rscript "{}"

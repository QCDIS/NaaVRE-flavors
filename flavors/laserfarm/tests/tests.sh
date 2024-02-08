#!/bin/sh
set -e
dir="${0%/*}"
find "$dir" -name "*.py" -print0 | xargs --null -I "{}" python "{}"

#!/bin/bash
#Description: extract URLs frow microsoft windows .URL files
grep --no-filename URL "$@" | cut -d"=" -f 1 --complement

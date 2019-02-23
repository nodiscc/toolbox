#!/bin/bash
#Description: find and remove files recursively with the given filename pattern
#Example: remove all .orig files: rmr *.orig.
#Source: https://github.com/Smotko/linux-tools/blob/master/rmr

find . -name $1 | xargs rm

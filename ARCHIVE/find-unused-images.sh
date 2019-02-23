#!/bin/bash
#Description: find images not linked from an HTML file
#Source: adapted from http://stackoverflow.com/questions/8161259/ and http://stackoverflow.com/questions/8887972/
#License: CC-BY-SA (http://creativecommons.org/licenses/by-sa/3.0/)

USAGE="USAGE: $0 path/to/images/ /path/to/file.html"

if [ "$1" = "" ]
	then echo $USAGE
	exit 1
fi

IMGPATH=$1
HTMLPATH=$2

find "$IMGPATH" \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \) -exec basename '{}' \;  >| /tmp/patterns

for p in $(cat /tmp/patterns); do
    grep -R "$p" "$HTMLPATH" > /dev/null || echo $p;
done

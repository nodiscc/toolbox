#!/bin/sh
#Description: extract a portion of a video file, write it to a new file
#License: CC-BY-SA (http://creativecommons.org/licenses/by-sa/3.0/)
#Source: http://askubuntu.com/a/59388


USAGE="`basename $0`: extract a portion of a video file, write it to a new file
USAGE: `basename $0` START_TIME DURATION ORIGINAL_FILE OUTPUT_FILE
START_TIME and DURATION are to be written in the format HH:MM:SS"

if [ "$1" = "" -o "$2" = "" -o "$3" = "" -o "$4" = "" -o "$1" = "-h" -o "$1" = "--help" ]
	then echo $USAGE
	else avconv -ss "$1" -t "$2" -i "$3" -vcodec copy -acodec copy "$4"
#	else echo $1 $2 $3 $4
fi
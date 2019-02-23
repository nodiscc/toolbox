#!/bin/bash
#Description: find all mp3s with a bitrate of 128k
#https://bbs.archlinux.org/viewtopic.php?id=92610

find . -name "*mp3" -type f -exec file '{}' \; | grep "128 kbps" | cut -d ':' -f 1 > 128kalbums.txt

# Find all mp3 in or under the current directory not in 320kbps.
#find . -name "*mp3" -type f -exec file '{}' \; | grep -v 320 | cut -d ':' -f 1

#Finds mp3 files with <320kbps.
#find . *.mp3 -print0|xargs -0 -n1 file|perl -e 'for(<stdin>){/(.*mp3).*?(\d+) kbps/;print "$1 $2\n" if ($2<320);}'


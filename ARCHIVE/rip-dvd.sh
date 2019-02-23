#!/bin/sh
#Description: rip a video DVD
# thanks to http://people.skolelinux.org/pere/blog/Ripping_problematic_DVDs_using_dvdbackup_and_genisoimage.html
# apt-get install lsdvd dvdbackup genisoimage
set -e
tmpdir=~/
title=$(lsdvd 2>/dev/null|awk '/Disc Title: / {print $3}')
dvdbackup -i /dev/dvd -M -o $tmpdir -n$title &&
genisoimage -dvd-video -o $tmpdir/$title.iso $tmpdir/$title &&
rm -rf $tmpdir/$title

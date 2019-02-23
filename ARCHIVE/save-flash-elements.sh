#!/bin/bash
#Author: <me@nileshgr.com>
#Description: Saves cached flash video from any running browsers (that use libflashplayer.so).
#File will be saved as a random string with extension .flv in the current directory.
#License: CC-BY-SA (https://creativecommons.org/licenses/by-sa/3.0/)

for p in $(pgrep -f libflashplayer.so -U `id -u`)
do
    for f in $(find /proc/$p/fd -type l)
    do
	filename=$(readlink $f)
	echo $filename | grep /tmp/Flash
	if [ $? -eq 0 ]
	then
	    dstfname=$(echo $filename | cut -d' ' -f1 | awk -F/ '{ print $NF }')
	    cp $f ${dstfname}.flv
	fi
    done
done
    	    

#!/bin/bash
#Description: play a random radio station from a list
set -e

player="mpv"

grep "url=" "$(dirname $0)/randomradiolist.txt" | awk -F"\"" '{print $2}' > parsed.txt
LINES=`cat parsed.txt | wc -l`
echo "lines: $LINES"
NUM=$RANDOM
echo "num: $NUM"
DICE=`bc -l <($($NUM/32767*$LINES)`
echo "dice: $DICE"
ROUNDED=` echo ${DICE%.*}`	
echo "rounded: $ROUNDED"
STATION=`sed -n "${ROUNDED}p" parsed.txt`
echo "selected station: $STATION"
"$player" "$STATION"
exit $?

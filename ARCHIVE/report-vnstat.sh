#!/bin/bash
#Description: Display vnstati network stats on pretty graphes

set -e

CDATE=`date +%s`
NETIFACE="wlan0"
OUTFILE="/tmp/vnstati-$CDATE"
SUMMARYFILE="/tmp/vnstati-summary-$CDATE.png"

if [ -x /usr/bin/eog ]
	then IMAGEVIEWER="eog"
elif [ -x /usr/bin/gpicview ]
	then IMAGEVIEWER="gpicview"
elif [ -x /usr/bin/feh ]
	then IMAGEVIEWER="feh"
elif [ -x /usr/bin/display ]
	then IMAGEVIEWER="display"
else
	echo "No suitable image viewer found. Aborting"
	exit 1
fi

STATUS_CHECK=`/etc/init.d/vnstat status`
if [ "$?" != "0" ]
	then echo "Warning: the 'vnstat' service is not running. Data may be outdated."
fi

vnstati -s -i $NETIFACE -o "$OUTFILE"s.png &&
vnstati -t -i $NETIFACE -o "$OUTFILE"t.png &&
vnstati -m -i $NETIFACE -o "$OUTFILE"m.png &&
vnstati -d -i $NETIFACE -o "$OUTFILE"d.png &&
vnstati -h -i $NETIFACE -o "$OUTFILE"h.png &&
montage -geometry +0+0 -tile 2x3 "$OUTFILE"s.png "$OUTFILE"t.png "$OUTFILE"m.png "$OUTFILE"d.png "$OUTFILE"h.png "$SUMMARYFILE" &&
$IMAGEVIEWER $SUMMARYFILE
rm $OUTFILE*
rm $SUMMARYFILE

#!/bin/bash
#Description: Look for words that are listed in $1/* , but not in $2/*.

USAGE="USAGE: `basename $0` /path/to/lists/ /path/to/other/lists/ [other_lists_to_exclude]"
PACKAGELISTSDIR="$1"
WIKIPATH="$2"
EXCLUDE_PATTERN=""

if [ "$3" != "" ]
	then EXCLUDE_PATTERN="--exclude=\"$3\""
fi

if [ "$1" = "" ] || [ "$2" = "" ]
	then echo "$USAGE"
	exit 1
fi

echo $EXCLUDE_PATTERN

############
for PATTERN in `cat $PACKAGELISTSDIR/rxtx*`
do
	if grep -rq "$PATTERN" "$WIKIPATH"
	then true
	else echo "$PATTERN not found"
	fi
done

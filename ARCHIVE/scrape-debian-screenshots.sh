#!/bin/bash
#Description: For each specified package, fetch a large screenshot from screenshots.debian.net
#TODO: colorize output
#TODO: report errors (CURLOPTS)
#TODO: "no screenshots for ..." is broken
set -e
set -o nounset

USERAGENT="Mozilla/4.0, debscreenshotgrabber"
SCREENSHOTSDIR="$PWD/screenshots"
#PACKAGES=$(cat $1|egrep -v "\#"|tr "\n" " ")
PACKAGES=$(egrep -v "^#" $@)
NEWFILES=""
ALREADY=""
NOTFOUND=""

mkdir -p $SCREENSHOTSDIR/rejected

for PACKAGE in $PACKAGES
do
	#Find large screenshots on screenshots.debian.net
	PACKAGE_SCREENS=$(curl -s -A "$USERAGENT" -f http://screenshots.debian.net/package/$PACKAGE | grep "large.png" | cut -f 4 -d "\"")

	#If no screenshots found, append to list
	if [ -z "$PACKAGE_SCREENS" ]
	then
		NOTFOUND="$NOTFOUND $PACKAGE"

	else
		for SCREENSHOT in $PACKAGE_SCREENS
		do
			FILENAME=$PACKAGE-`basename $SCREENSHOT`
			#If file already exists (alreadyd downloaded), skip"
			if [ -f "$SCREENSHOTSDIR/$FILENAME" -o -f "$SCREENSHOTSDIR/rejected/$FILENAME" ]
			then ALREADY="$ALREADY $FILENAME"
			
			#Else download it
			else wget --quiet -U "$USERAGENT" -nv -O "$SCREENSHOTSDIR/$FILENAME" http://screenshots.debian.net/$SCREENSHOT
			
			NEWFILES="$NEWFILES $FILENAME"
			sleep 1;
			fi
		done
	fi

done

echo "Already downloaded screenshots: $ALREADY"
echo "Newly retrieved files: $NEWFILES"
echo  -e "\033[00;31mPackages without screenshots: $NOTFOUND\033[00m"

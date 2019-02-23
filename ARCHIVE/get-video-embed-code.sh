#!/bin/bash
#Description: create embed codes for Youtube or Vimeo videos from their URLs.

getembedcode() {
#if URL contains vimeo
if [[ "$1" == *vimeo* ]]
then
	EMBEDCODE="<iframe src=\"http://player.vimeo.com/video/VIDEOID?title=1&amp;byline=1&amp;portrait=0\" width=\"470\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"

elif [[ "$1" == *youtube* ]]
then
	VIDEOID=`echo $1 | sed 's/.*v=//' | cut -f 1 -d "&"`
	checkvideoid $VIDEOID
	EMBEDCODE="<iframe width=\"470\" src=\"https://www.youtube-nocookie.com/embed/$VIDEOID\" frameborder=\"0\" allowfullscreen></iframe>"
fi
echo -e "\n$EMBEDCODE\n"
}


checkvideoid() {
if [[ "$1" =~ [\ \/\$\'\"\*\?] ]]
then
	echo "ERROR: Invalid Video ID. ID must not contain special characters."
	exit 1
fi
}


getembedcode $1

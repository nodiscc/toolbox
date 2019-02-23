#!/bin/bash
# Description: Create a markdown/dokuwiki link to a Debian package page
# Optionnally add bullets
# Links are formatted like package_name_and_page_link - package_description - package_homepage
# License: MIT (http://opensource.org/licenses/MIT)
# Copyright: (c) 2013 nodiscc <nodiscc@gmail.com>

#Init variables
MARKDOWN=""
BULLETED=""
MODE=""
OPTS_ENABLED="0"
USAGE="Usage: `basename $0` [OPTIONS] [package names] [URL]
Description: Generate dokuwiki or markdown links for debian packages or URLs

OPTIONS:
    -m    enable markdown mode
    -b    enable bullet list
    -w    only generate link to homepage
    -u    generate link for an URL
    "

#if [ "$1" = "-h" -o "$1" = "" ]
#	then echo "$USAGE"
#fi

#Check options and select appropriate text for bullet lists
while getopts ":wmbhu" opt; do
	case $opt in
	h)
	echo "$USAGE"
	exit 1
	;;
	u)
	MODE="url"
	OPTS_ENABLED="1"
	;;
	w)
	MODE="homepage_only"
	OPTS_ENABLED="1"
	;;
	m)
	MARKDOWN="1"
	OPTS_ENABLED="1"
	;;
	b)
	BULLETED="1"
	OPTS_ENABLED="1"
	;;
	/?)
	echo "Invalid option: -$OPTARG" >&2
	exit 1;;
	esac
done

#Load proper bullet style
if [[ "$MARKDOWN" = "1" && "$BULLETED" = "1" ]]
	then BULLET=" * "
elif [[ "$MARKDOWN" = "" && "$BULLETED" = "1" ]]
	then BULLET="  * "
elif [[ "$MARKDOWN" = "1" && "$BULLETED" = "" ]]
	then BULLET=""
elif [[ "$BULLETED" = "" ]]
	then BULLET=""
fi

#Shift from 
shift $OPTS_ENABLED


#Run
ARGS="$@"

##URL mode
if [ "$MODE" = "url" ]
then
	for RESURL in $ARGS
        do
        	RESOURCETITLE=`wget --no-check-certificate "$RESURL" -q -O - | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}'`
        	
        	if [ "$MARKDOWN" = "1" ]
	        then #Markdown syntax
	        	echo "${BULLET}[$RESOURCETITLE]($RESURL)"
        	else #Dokuwiki syntax
        		echo "${BULLET}[[$RESURL|$RESOURCETITLE]]"
        	fi
	done
	exit 0
fi



##Debian Package mode
for pack in $ARGS;
do
	PACKAGE_DESCR=`apt-cache show $pack | egrep "^Description" |egrep -v "Description-md5"| uniq | cut -d " " -f2-`;
	HOMEPAGE=`apt-cache show $pack | egrep "^Homepage" | uniq | cut -d " " -f2-`;

	if [ "$MARKDOWN" = "1" ]
	then #Markdown syntax
		if [[ "$MODE" != "homepage_only" ]]
		then
			echo -n "${BULLET}[$pack](http://packages.debian.org/wheezy/$pack) - $PACKAGE_DESCR";
		fi
		if [[ "$HOMEPAGE" != "" ]]
		then
			echo " ([Site Officiel]($HOMEPAGE))"
		else
			echo
		fi
	else #Dokuwiki syntax
		if [[ "$MODE" != "homepage_only" ]]
		then
			echo -n "${BULLET}[[http://packages.debian.org/wheezy/$pack|$pack]] - $PACKAGE_DESCR";
		fi
		if [[ "$HOMEPAGE" != "" ]]
		then
			echo " ([[$HOMEPAGE|Site Officiel]])"
		else
			echo
		fi
	fi
done

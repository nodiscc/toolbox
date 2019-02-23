#!/bin/bash
#Description: Get newest or random wallpapers from Wallbase.cc, search, remove duplicates
#Source: https://raymii.org/s/software/Wallbase.cc_Command_line_script.html
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright (c) 2012 Remy van Elst
#See also https://www.reddit.com/r/bash/comments/2d2rwe/wallbasesh_the_automated_wallpaper_downloader/

#first the vars
BASEURL="http://wallbase.cc/search/"
MODE="$1"
SEARCH="$2"
NEWWALLURL="http://wallbase.cc/search/0/0/213/eqeq/0x0/0/1/1/0/60/relevance/desc/wallpapers"
WALLR="http://wallbase.cc/random/"
CONFIGS="/0/213/eqeq/0x0/0/1/1/0/60/relevance/desc/wallpapers"

#now see what we need to do
case "$1" in
   s)
   if [ -e $2 ]; then
      echo "I need search terms"
      exit 1
   fi
   GETURL="$BASEURL$SEARCH$CONFIGS"
   ;;
   n)
   GETURL="$NEWWALLURL"
   ;;
   r)
   GETURL="$WALLR"
   ;;
   *)
   echo -e "Usage: $0 r for random, $0 n for newest, $0 s TERM for search TERM."
   exit 1
   ;;
esac

GETURL=$WALLR
#get the wallpaper overview page, grep the wallpaper page urls and dump them into a file for wget
wget -q --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120403211507 Firefox/12.0" $GETURL -O- | egrep -o "http://[^[:space:]]*" | grep "/wallpaper/" | sed 's/"//g' > ./wallist

#put the url file in a variable, but first backup IFS and later restore it.
OLDIFS=$IFS
IFS='
'
urlsa=( $( < ./wallist ) )
IFS=$OLDIFS

#now loop trough the urls and wget the page, then grep the wallpaper URL, and then wget the wallpaper
for i in "${urlsa[@]}"
do
  echo $i
  wget -vv --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120403211507 Firefox/12.0" $i -O- | wget -vv -nd -nc `egrep -o "http://[^[:space:]]*.jpg"`
done

#now a duplicate check...
find -not -empty -type f -printf "%sn" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 | cut -d" " -f3 | xargs -P 10 -r -n 1 rm
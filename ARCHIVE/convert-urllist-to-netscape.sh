#!/bin/bash
# Description: Converts a plaintext list of links to netscape HTML bookmarks format
# Fetches page title from the website.
set -o errexit
set -o nounset
##############
textfile="links.txt"
output_html_file="output-netscape.html"
wget_useragent="Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0"
wget_timeout="15"
##############
date=$(date +%s)
echo "" >| "$output_html_file"
# find all URLs in file, 
# remove trailing "**" if necessary (markdown bold formatting)
urllist=$(egrep --only-matching 'http(s)?\://[^ "\*\*"]*' "$textfile")
numlinks=$(echo "$urllist" | wc -l)
echo "[info] Found $numlinks links"
i=1
for pageurl in $urllist; do
    echo "[info] [$i/$numlinks] Processing $pageurl"
    ((i++))
    date=$(( $date + 1 ))
    pagetitle=$(wget "$pageurl" --timeout="$wget_timeout" --user-agent="$wget_useragent" -q -O - | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}') #extract webpage title
    if [ "$pagetitle" = "" ]; then pagetitle="$pageurl"; fi
    htmlentry="<DT><A HREF=\"$pageurl\" ADD_DATE=\"$date\">$pagetitle</A>"
    echo "$htmlentry" | tee -a "$output_html_file"
done
echo "[info] Completed. output saved to $output_html_file"
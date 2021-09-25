#!/bin/bash
#Description : get information from currently running quodlibet instance
set -o errexit
set -o nounset

[[ -e ~/.quodlibet/control ]] || exit
cover_vpos=${1:-0}
current_info=$(cat ~/.quodlibet/current) || current_info=""
TITLE=$(echo "$current_info" | grep 'title=' | cut -d"=" -f 1 --complement | cut -b 1-25)
if [[ "$TITLE" == "" ]]; then
    TITLE=$(echo "$current_info" | grep 'filename=' | cut -d"=" -f 1 --complement | xargs -0 basename | cut -b 1-25)
fi
ALBUM=$(echo "$current_info" | grep 'album=' | cut -d"=" -f 1 --complement | cut -b 1-25)
ARTIST=$(echo "$current_info" | grep 'artist=' | cut -d"=" -f 1 --complement | cut -b 1-25)

# shellcheck disable=SC2016
if [[ -f ~/.quodlibet/current.cover ]]; then
	echo "\${image ~/.quodlibet/current.cover -p 0,$cover_vpos -s 100x100 -f 10}"
else
	echo "\${image /opt/conky-scipts/media-optical.png -p 0,$cover_vpos -s 100x100 -f 10}"
fi
echo -e "\${goto 115}$ARTIST"
echo -e "\${goto 115}$TITLE"
echo -e "\${goto 115}$ALBUM"

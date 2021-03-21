#!/bin/bash
#Description : get information from currently running quodlibet instance
[[ -e ~/.quodlibet/control ]] || exit
cover_vpos=${1:-0}
current_info=$(cat ~/.quodlibet/current) || current_info=""
TITLE=$(echo "$current_info" | grep 'title=' | cut -d"=" -f 1 --complement | cut -b 1-25)
ALBUM=$(echo "$current_info" | grep 'album=' | cut -d"=" -f 1 --complement | cut -b 1-25)
ARTIST=$(echo "$current_info" | grep 'artist=' | cut -d"=" -f 1 --complement | cut -b 1-25)

# shellcheck disable=SC2016
if [[ -f ~/.quodlibet/current.cover ]]; then
	echo "\${image ~/.quodlibet/current.cover -p 0,$cover_vpos -s 100x100 -f 10}"
else
	echo '${image /media/EXT4-2TB-A/DOWNLOADS/media-optical.png -p 0,260 -s 100x100 -f 10}'
fi
echo -e "\${goto 115}$ARTIST"
echo -e "\${goto 115}$TITLE"
echo -e "\${goto 115}$ALBUM"

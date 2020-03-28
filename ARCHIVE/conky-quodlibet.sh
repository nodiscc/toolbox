#!/bin/bash
#Description : get information from currently running quodlibet instance
[[ -e ~/.quodlibet/control ]] || exit
TITLE=$(grep 'title=' ~/.quodlibet/current | cut -d"=" -f 1 --complement | cut -b 1-18)
ALBUM=$(grep 'album=' ~/.quodlibet/current | cut -d"=" -f 1 --complement | cut -b 1-18)
ARTIST=$(grep 'artist=' ~/.quodlibet/current | cut -d"=" -f 1 --complement | cut -b 1-18)

# shellcheck disable=SC2016
if [[ -f ~/.quodlibet/current.cover ]]; then
	echo '${image ~/.quodlibet/current.cover -p 0,260 -s 100x100 -f 10}'
else
	echo '${image /media/EXT4-2TB-A/DOWNLOADS/media-optical.png -p 0,260 -s 100x100 -f 10}'
fi
echo -e "\${goto 115}$ARTIST"
echo -e "\${goto 115}$TITLE"
echo -e "\${goto 115}$ALBUM"

#!/bin/bash
# Description: Add Playstation games to lutris game library, from a directory of .iso files
# Status: PROTOTYPE
# BUGS: error when running the game:

# Traceback (most recent call last):
#   File "/usr/lib/python3/dist-packages/lutris/gui/lutriswindow.py", line 409, in update_revealer
#     self.game_bar = GameBar(game, self.game_actions, self.application)
#   File "/usr/lib/python3/dist-packages/lutris/gui/widgets/game_bar.py", line 30, in __init__
#     self.service = services.get_services()[db_game["service"]]()
# KeyError: '0.0'

# Author: nodiscc@gmail.com
# License: GPL-3.0
# Usage: generate-lutris-game-yml.sh /path/to/iso/directory

set -o errexit
set -o nounset
iso_directory="$1"
yml_directory="${iso_directory}/lutris"

function sanitize_filename {
	input_string="$*"
	# first, strip dashes
	clean_filename=${input_string//- /}
	# next, replace spaces with dashes
	clean_filename=${clean_filename// /-}
	# now, clean_filename out anything that's not alphanumeric or an underscore
	clean_filename=${clean_filename//[^a-zA-Z0-9\-]/}
	# finally, lowercase with TR
	clean_filename=$(echo -n $clean_filename | tr A-Z a-z)
	echo "$clean_filename"
}

if [[ ! -d "$yml_directory" ]]; then
	mkdir -p "$yml_directory"
fi

isofiles=$(find "${iso_directory}" -maxdepth 1 -type f -iname "*.zip")
timestamp=$(date +%s)
db_last_index=$(sqlite3 ~/.local/share/lutris/pga.db 'select * from games;' | tail -n1 | grep --only-matching "^[0-9]*")
db_next_index=$(( db_last_index + 1 ))

for i in $isofiles; do
	timestamp=$(( timestamp + 1 ))
	filename=$(basename "$i")
	echo "filename: $filename"
	read -p "Enter game title (leave empty to skip this file): " gametitle
	if [[ ! "$gametitle" == "" ]]; then
		sanitized_title=$(sanitize_filename $gametitle)
		yml_filename="${yml_directory}/${sanitized_title}-${timestamp}.yml"
		echo "writing to $yml_filename ..."
		echo "game:" >| "$yml_filename"
		echo "    core: pcsx_rearmed" >> "$yml_filename"
		echo "    main_file: $i" >> "$yml_filename"
		echo "libretro: {}" >> "$yml_filename"
		echo "system: {}" >> "$yml_filename"
		echo "writing database entry ..."
		sqlite3 ~/.local/share/lutris/pga.db "INSERT INTO games VALUES ('$db_next_index','$gametitle','$sanitized_title','','','Sony PlayStation','libretro','','','',0,1,$timestamp,'','','','${sanitized_title}-${timestamp}','','',0.0,0);"
		db_next_index=$(( db_next_index + 1 ))
	fi
done


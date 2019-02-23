#!/bin/bash
#Description: list all torrents in a directory, output their hash and name
for i in *.torrent; do
Name=$(transmission-show "$i" | grep " Name: " | awk -F" " '{$1=""; print $0}')
Hash=$(transmission-show "$i" | grep " Hash: " | awk -F" " '{print $2}')
#Size=$(transmission-show "$i" | grep " Total Size: " | awk -F" " '{print $2 $3}')
echo " * $Name \`$Hash\`"
done
#!/bin/bash
# Description: Conky slideshow
# Authors: (c) Alessandro Roncone 2012
# Version: 0.2
# License: GNU GPLv3

###################
# Settings
if [[ -f "$HOME/.config/conky/config" ]]
	then source "$HOME/.config/conky/config"
	else echo -e "IMAGESDIR=\"\"" >> ~/.config/conky/config
fi
# Directory containing the script and the pictures
directory="$IMAGESDIR"
# Dimension of the slideshow (either "small", "medium" or "big")
dim="big"

##################
# Script
# Manage dimension flag
if [[ $dim == "small" ]]; then
  geometry="158x100"
  pos="155,214"
elif [[ $dim == "medium" ]]; then
  geometry="238x148"
  pos="85,175"
elif [[ $dim == "big" ]]; then
  geometry="318x200"
  pos="0,119"
fi

# Pick a random file from all pictures
files=($directory/*.*)
let r="$RANDOM % ${#files[*]}"
randomfile=${files[$r]}

# Sets picture for conky to use
convert "$randomfile" -resize $geometry\> -size $geometry xc:black +swap -gravity center  -composite /usr/share/conky/images/current.png
convert /usr/share/conky/images/photobg_bg_$dim.png /usr/share/conky/images/current.png -geometry +11+11 -composite /usr/share/conky/images/result.png
convert /usr/share/conky/images/result.png /usr/share/conky/images/photobg_shadow_$dim.png -composite /usr/share/conky/images/result.png
echo "\${image /usr/share/conky/images/result.png -p $pos}"
exit

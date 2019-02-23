#!/bin/bash
# Description: Create polaroid-like pictures from photos in a specified directory, group them by 6 on A4 format pages
# Picture size is fixed to 300x300 px, you may need to adjust sizes or resize your original photos
# Original files are not touched, and backed up to a backups/ directory next to them, just in case
# License: WTFPL
# Authors: nodiscc@gmail.com
# Requirements: imagemagick

#### CONFIGURATION #####

photosdir="$HOME/test" # Directory where original photos are stored
message="Your message here" # Message on final photo

########################

#create directories
mkdir -p "$photosdir/backups"
mkdir -p "$photosdir/cut"
mkdir -p "$photosdir/polaroid"
mkdir -p "$photosdir/pages"

# backup photos
cp $photosdir/*.jpg "$photosdir/backups/"

# list all photos in backups directory
allphotos=$(find "$photosdir/backups" -maxdepth 1 -iname "*.jpg")
echo "$allphotos"

# Cut photos
echo "$allphotos" | while read photo; do
        photo_filename=$(basename "$photo")
        echo "Cutting $photo_filename ..."
        convert -crop 520x480+60+0 "$photo" "$photosdir/cut/$photo_filename"
done

# Apply polaroid effect
for cut_photo in $photosdir/cut/*.jpg; do
        cut_photo_filename=$(basename "$cut_photo")
        echo "Applying polaroid effect to $cut_photo_filename ..."
        convert -size 338x360 canvas:white -background none "$cut_photo" -geometry 300x300+19+19 \
        -composite -interpolate nearest -rotate 90  -rotate -90 +swap -background none \
        -bordercolor grey -border 1x1 -gravity west -font "DancingScript" -pointsize 25 \
        -annotate +55+150 "$message"  -layers merge "$photosdir/polaroid/$cut_photo_filename"
done


# Generate 2x3 grids from final photos
L=3 #number of lines
C=2 #number of columns
finalphotoslist=$(find "$photosdir/polaroid/" -maxdepth 1 -iname *.jpg) #list of all photos in final/
sixfiles=$(echo "$finalphotoslist" | xargs -n6) #grouped by 6
pagenumber=1 #initial page number
echo "$sixfiles" | while read files; do
	montage +frame +shadow +label -tile $Lx$C -geometry +0+0 $files "$photosdir/pages/page-$pagenumber.jpg"
	echo "Image grid exported to pages/page-$pagenumber.jpg"
	pagenumber=$((pagenumber + 1))
done


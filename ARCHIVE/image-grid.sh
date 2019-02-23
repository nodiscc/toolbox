#!/bin/bash
# Description: concatenates images to a single grid of images
# TODO: sanitize input for $N and $M (only allow numbers)
# TODO: colorize output

NUMBER_OF_FILES=`echo "$@" | wc -w`
N=11 #number of lines
M=3 #number of columns
OUTFILE=joined.jpg

echo "You have selected $NUMBER_OF_FILES files for processing. Please select \
an appropriate size for the image grid.
Number of lines:"
read N
echo "Number of columns:"
read M

montage +frame +shadow +label -tile $Nx$M -geometry +0+0 $@ $OUTFILE

echo "Image grid exported to $OUTFILE"

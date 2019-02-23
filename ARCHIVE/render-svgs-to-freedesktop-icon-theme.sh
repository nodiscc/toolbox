#!/bin/bash
#Description: For each .svg file, render it to standard freedesktop icon sizes,
#and place rendered .png files in appropriate $SIZE subdirectories

for file in *.svg
do
	for size in 16 22 24 32 48 64 96;
	do mkdir $size
	rsvg -w $size -h $size $file $size/`basename $file .svg`.png
	done
done

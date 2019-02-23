#!/bin/bash
#Description: Create a freedesktop-compliant icon theme from a directory of SVG images.

USAGE="USAGE: `basename $0` svg_directory rendered_directory"
SVGDIR="$1"
RENDERDIR="$2"

if [ "$1" = "" -o "$2" = "" ]
	then echo "$USAGE"
	exit 1
fi

if [ ! -d "$1" -o ! -d "$2" ]
	then echo "One of the specified directories appears to be invalid"
	exit 1
fi


for SIZE in 16 22 24 32 48 64;
do mkdir "$RENDERDIR/$SIZE"
	for SVG in `find "$SVGDIR" -name *.svg`;
		do
		ICONNAME=`basename "$SVG" .svg`
		convert -resize "$SIZE"x"$SIZE" "$SVG" "$RENDERDIR/$SIZE/$ICONNAME.png"
	done
done

mkdir "$RENDERDIR/scalable"
for SVG in `find "$SVGDIR" -name *.svg`;
do
	cp "$SVG" "$RENDERDIR"/scalable/
done


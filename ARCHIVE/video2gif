#!/bin/bash
#Description: Convert videos to animated GIFs
#Thanks http://xmodulo.com/convert-video-animated-gif-image-linux.html
#License: CC-BY-SA http://creativecommons.org/licenses/by-sa/3.0/
infiles="$@"

for video in $infiles; do
ffmpeg -i "$video" -pix_fmt rgb24 out%04.gif
framerate=$(mediainfo "$video" | grep "Frame rate" | awk '{print $4}' | cut -d"." -f1)
convert -delay 1x"$framerate" -loop 0 out*.gif "$video".gif
rm out*.gif
#rm "$video"
#mogirfy -layers Optimize "$video".gif
done
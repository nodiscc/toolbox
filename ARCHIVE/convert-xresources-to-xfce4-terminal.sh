#!/bin/bash
#Description: Create XFCE Terminal colorschemes from Xresources/Xdefaults files
#Place resulting .theme files in /usr/share/xfce4/terminal/colorschemes/
# u/evaryont  http://redd.it/15z69z
#TODO: does not work for all xdefaults files (see space_supreme.xdefaults)

XRESFILE="$1"
TEMPFILE=""
ARRAY=""

grep -q "define" "$XRESFILE"
if [ "$?" = 0 ] #cpp-style file detected
	then TEMPFILE=`mktemp`
	cpp < "$XRESFILE" > "$TEMPFILE"
	XRESFILE="$TEMPFILE"
fi

number=0
while [ $number -lt 16 ]
do
        ARRAY=`echo $ARRAY ; egrep "URxvt.color$number[\: ]|\*color$number[\: ]" $XRESFILE | egrep -v "^\!"| awk '{print $NF}'`
        number=$(($number+1))
done

PALETTEVALUE=`echo $ARRAY | sed 's/\ /\;/g'`
X_BACKGROUNDVALUE=`grep background $XRESFILE | awk '{print $NF}'`
X_FOREGROUNDVALUE=`grep foreground $XRESFILE | awk '{print $NF}'`


BACKGROUNDVALUE_PART1=${X_BACKGROUNDVALUE:1:2}
BACKGROUNDVALUE_PART2=${X_BACKGROUNDVALUE:3:2}
BACKGROUNDVALUE_PART3=${X_BACKGROUNDVALUE:5:2}
BACKGROUNDVALUE="#$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART3"

FOREGROUNDVALUE_PART1=${X_FOREGROUNDVALUE:1:2}
FOREGROUNDVALUE_PART2=${X_FOREGROUNDVALUE:3:2}
FOREGROUNDVALUE_PART3=${X_FOREGROUNDVALUE:5:2}
FOREGROUNDVALUE="#$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART3"


THEMENAME=`basename $1 | awk -F "\." '{print $1}' 2>/dev/null`

CONTENTS=`
echo "[Scheme]"
echo "Name=${THEMENAME}"
echo "ColorPalette=$PALETTEVALUE"
echo "ColorForeground=$FOREGROUNDVALUE"
echo "ColorCursor=$FOREGROUNDVALUE"
echo "ColorBackground=$BACKGROUNDVALUE"`

echo "Writing ${THEMENAME}.theme file..."
echo "${CONTENTS}" > "${THEMENAME}".theme

if [ -f "$TEMPFILE" ]
	then rm "$TEMPFILE"
fi

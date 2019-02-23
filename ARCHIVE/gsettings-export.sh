#!/bin/bash
#Description: reads all current GSettings values and creates a .schema.override
#that can be used to provide default GSettings values for vendor installations.
#Needs libglib2.0-bin, bash, awk
# http://www.burtonini.com/blog/computers/gsettings-override-2011-07-04-15-45

#Create override file
gsettings list-schemas | while read SCHEMA; do
	echo -e "\n[$SCHEMA]";
	gsettings list-recursively $SCHEMA 2>/dev/null | egrep -v "$SCHEMA\." |  awk '{ print $2 "=" $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $20 $21 $22 $23 $24 $25 $26 $27 $28 $29 $30 $31 $32 $33 $34 $35 $36 $37 $38 $39 $40}'
done

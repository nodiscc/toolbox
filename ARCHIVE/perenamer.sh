#!/bin/bash
#Description: Renames PDFs based on text contents
#Requires pdfgrep

for i in 20*.pdf
do

if [[ `pdfgrep "RELEVE DE SITUATION" "$i" 2>/dev/null` ]]
then
	SUBJECT="Relevé de situation"
else
	SUBJECT=`pdfgrep Objet "$i" 2>/dev/null | cut -f 1-2 -d " " --complement  | sed -e "s/'/_/g"`
fi

DOCDATE=`pdfgrep ", le " "$i" 2>/dev/null | awk '{print ( $(NF) " " $(NF-1) " " $(NF-2) )}'` #TODO convert 3 last fields to standard date
NEWNAME="Assurance ${SUBJECT} ${DOCDATE}.pdf"

mv $i "$NEWNAME"
done

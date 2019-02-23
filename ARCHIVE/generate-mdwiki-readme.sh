#!/bin/bash
#Description: Generate index.md files for use with MDWiki. Run in doc/notes/blog directory

# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.

# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

##########################################
##########################################
#TODO: handle spaces in filenames (eg. Fabrication de la chaux en pâte.pdf)
#TODO: some filenames break markdown links (Where_there_is_no_doctor-2011(en)-red.pdf)
#TODO: make optimization optional
#TODO: optimize PDFs, partially implmented, make it optional
#TODO: images: one image by line?
##########################################
##########################################

# Settings for PDF optimization
# http://milan.kupcevic.net/ghostscript-ps-pdf/
# Note that setting high quality values may result in a file larger than the original
# Possible values default, screen, ebook, printer, prepress
pdf_quality="ebook"
optimize_images="false"
local_mdwiki="true"
mdwiki_url="https://mdwiki.org/mdwiki-0.6.2/mdwiki.html"
mdwiki_localfile="~/git/notes/index.html"
set -o errexit
# set -o verbose
# set -o nounset
# set -o xtrace


######### Main loop ######################

main() {
	page_title=$(basename $(pwd)) #The main title
	echo "# $page_title"
	echo ""

	_PrintReadme
	_PrintSubdirs
	_PrintArticles
	echo -e "\n-----------------------------------\n"
	_PrintOtherFiles
	echo -e "\n-----------------------------------\n"
	_PrintImages

	if [ ! -f index.html ]
		then
		if [ "$local_mdwiki" = "true" ]
			then cp "$mdwiki_localfile" index.html
			else wget "$mdwiki_url" -O index.html
		fi
	fi
}

######### Functions ######################

_PrintReadme() { #Print README.md to the file
	if [ -f README.md ]; then
	echo "#### [README.md](README.md)"; cat README.md; echo ""
	echo -e "\n-----------------------------------\n"
	fi
}

_PrintSubdirs() { #Print a list of subidrectories
	subdirs=$(find ./ -mindepth 1 -maxdepth 1 -type d | \
	sed 's|_media||g' | \
	sed 's|\./||g' | \
	sed 's|\.git||g') #TODO this is dirty, use find's exclude option to ignore these dirs

	if [ "$subdirs"	!= "" ]; then
		echo "#### Dossiers"
		for dir in $subdirs;do
			if [ -f "$dir/index.html" ]; then echo "[$dir]($dir/index.html)"
			else echo "[$dir]($dir)"
			fi
		done
		echo -e "\n-----------------------------------\n"
	fi
}

_PrintArticles() { #Print a list of .txt/.md articles with tags,date and a short extract
	echo "#### Articles"
	#fileitems=$(ls -lt --time-style=+%d/%m/%Y *.md *.txt | egrep -v " index.md$") #TODO DO NOT PARSE FUCKING LS,
	#use find ./ -exec stat -c "%n %Y" {} \; to get the time, exclude index.md and README.md

	export fileitems=$(find ./ -maxdepth 1 -name "index.md" -o -name "README.md" -prune -o -name "*.md"  -exec stat -c "%n %y" '{}' \;)

	if [ "$fileitems" != "" ]; then
		echo "$fileitems" | while read line
		do
			export filename=$(echo "$line" | awk -F" " '{print $1}')
			export filename=$(basename "$filename")
			export filedate=$(echo "$line" | awk -F" " '{print $2}')

			doctitle=$(egrep "^# " "$filename"  | head -n1 | sed 's/# //g')
			if [ "$doctitle" = "" ]; then doctitle="$filename"; fi

			doctags=$(egrep "^@" "$filename"  | head -n1)
			if [ "$doctags" = "" ]; then doctags="";
			else doctags="\`$doctags\`"; fi

			docextract=$(head -n5 "$filename" |egrep "(^[a-Z]|^\[)" |  cut -b 1-130 | head -n1)
			if [ "$docextract" != "" ]; then docextract="$docextract [...]"; fi

			if [ "$filename" != "README.md" ]; then
				mdline="**[$doctitle]($filename)** _<small>${filedate}</small>_ $doctags"

				echo "$mdline"
				if [ "$docextract" != "" ]; then echo "<small>$docextract</small>"; fi
				echo " "
			fi
		done
	fi
}



_PrintOtherFiles() { #Print a list of other files
	otherfiles=$(find ./ -maxdepth 1 -type f | \
	egrep -v "(index\.html$|\.md$|\.txt$|\.png$|\.jpg$|\./update-readme.sh)" | \
	sed 's|\./||g')

	if [ "$otherfiles" != "" ]
		then echo "#### Other files"
		for file in $otherfiles; do
			echo "[$file]($file)"
		done
	fi
}



_PrintImages() { #Print a list of images
	#TODO: sort images by date
	imageitems=$(find ./ -mindepth 1 -maxdepth 1 -name "*.jpg" -o -name "*.png" | \
	egrep -v "_media/")

	if [ "$imageitems" != "" ]
	then echo "#### Images"
		for image in $imageitems
		do echo -e "![]($image)\n"; done
		echo ""
	fi
}


_Recurse() { # Just a wrapper to get a list of directories, sorted by descending depth
	tree -I "_media" -fid "$PWD" | head -n -2 |tac
}

_GetPdfData() { #Extract metadata from PDF
pdfinfo "$1" | sed -e 's/^ *//;s/ *$//;s/ \{1,\}/ /g' -e 's/^/  \//' -e '/CreationDate/,$d' -e 's/$/)/' -e 's/: / (/' | sed '1s/^ /[/' | sed '/:)$/d'
echo "  /DOCINFO pdfmark"
}

_CompressPdf() { #Optimize PDF files
	_GetPdfData "$1" > .pdfmarks
	 gs -sDEVICE=pdfwrite \
	 -dCompatibilityLevel=1.4 \
	 -dPDFSETTINGS=/"$pdf_quality" \
	 -dNOPAUSE -dQUIET -dBATCH \
	 -sOutputFile="pdfcomp/$pdf_quality.pdf" \
	 "$1" .pdfmarks
	 rm .pdfmarks
}

######################################################

# Optimize images recursively before starting; This should probably be optional...
# I've tried to reduce quality using mogrify -quality 80, but it sometimes increases the original image size.
# The only better way is to run identify --verbose | grep Quality, and only apply mogify if the quality is
# higher than 80...

_OptimizeImages() {
	if [[ "$optimize_images" = "true" ]]
		then
		find "$PWD" -iname *.jpg -exec jpegoptim '{}' \;
		find "$PWD" -iname *.png -exec optipng '{}' \;
	fi
}

# Run it

_OptimizeImages
for dir in $(_Recurse); do
	cd "$dir"
	main >|index.md
done


#!/bin/bash
#Description: sort Photorec recovered files in subdirectories named from file extensions
#http://www.cgsecurity.org/wiki/PhotoRec
#TODO: http://www.reddit.com/r/linux/comments/1w40mt/need_a_text_file_browser_to_make_sifting_through/ceyhuhd

#check for root permissions
if [ `whoami` = "root" ]; then
	true
	else echo "You are not root."; exit 1
fi

cd $1

#create a directory in ./sorted-files/ for each filetype encountered
for extension in `find ./ -type f | sed 's/.*\.//'`; do mkdir -p ./sorted-files/$extension; done

#move each filetype in it's directory in ./sorted-files/
for ft in `ls ./sorted-files/` ; do find ./ -type f -name "*.$ft" -prune ./sorted-files -exec mv {} ./sorted-files/$ft/ \; ; done

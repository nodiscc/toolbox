#!/bin/bash
find ./ -iname "????????????????????????????????????????.torrent" | while read file; do
	NAME=$(transmission-show "$file" | grep "  Name: " | sed -s 's/  Name: //g'); 
	HASH=$(transmission-show "$file" | grep "  Hash: " | sed -s 's/  Hash: //g'); 
	mv "$file" "$NAME-$HASH.torrent";
done

# name=$(transmission-show "$i"  | grep '^  Name:' | cut -d ' ' -f1-3 --complement); mv -v "$i" "$name.$i"

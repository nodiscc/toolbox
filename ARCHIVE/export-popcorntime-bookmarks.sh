#!/bin/bash
#Description: print titles of bookmarked movies/shows in Popcorntime https://popcorntime.sh

ids=$(cat ~/.config/Popcorn-Time/data/bookmarks.db | egrep --only-matching "tt[0-9]*"); 
for id in "$ids"; do
	grep "$id" ~/.config/Popcorn-Time/data/movies.db ~/.config/Popcorn-Time/data/shows.db | \
	egrep --only-matching 'title"\:".*' ;
done | cut -d"," -f1


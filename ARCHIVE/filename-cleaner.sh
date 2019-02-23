#!/bin/bash
#Description: cleanup/standardize filenames in a directory
# A replacement for fclean and fclean_dir
# Source: http://crunchbang.org/forums/viewtopic.php?pid=357373#p357373
# searches recursively through directory for files with un-unixy names, and makes them cleaner
# replaces capitals with lowercase
# replaces spaces with underscores
# removes any characters not in the set [a-z0-9_.]
# leaves a log file, detailing the name changes
# NOTE: Be careful when using this on your home directory, as it may change the names of configuration files
# For instance, .Xauthority and .Xresources would be renamed

find . -name "*[A-Z ]*" -exec rename -v 'tr/[A-Z][ ]/[a-z][_]/' '{}' > .cleaner.log \; 
find . -name "*[\!\?\,\[\]\{\}\(\)]*" -exec rename -v 's/[^\w\.\/]//g' '{}' > .cleaner.log \;